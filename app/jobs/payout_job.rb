class PayoutJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    Rails.logger.info "---- PayoutJob START record_id=#{record_id} ----"

    webhook = Webhook.find_by(id: record_id)
    return unless webhook && !webhook.processed?

    data = JSON.parse(webhook.payload)
    pi   = data["data"]["object"]   # Stripe PaymentIntent object

    user_id    = pi["metadata"]["user_id"]
    course_ids = JSON.parse(pi["metadata"]["course_ids"])

    Rails.logger.info "User ID: #{user_id}, Course IDs: #{course_ids.inspect}"

    # --------------------------
    # 1) ENROLL USER TO COURSES
    # --------------------------
    user = User.find(user_id)

    course_ids.each do |cid|
      Enrollment.find_or_create_by(user_id: user.id, course_id: cid)
    end

    # --------------------------
    # 2) PAYOUTS TO INSTRUCTORS
    # --------------------------
    payout_items = []

    course_ids.each do |cid|
      course     = Course.find(cid)
      instructor = course.instructor
      earning    = course.amount

      Rails.logger.info "Processing payout for Course #{course.id} | Instructor #{instructor.id}"

      begin
        transfer = Stripe::Transfer.create(
          amount: (earning * 100).to_i,   # Amount in cents
          currency: "usd",
          destination: instructor.stripe_account_id,
          transfer_group: "course_#{cid}"
        )

        Rails.logger.info "TRANSFER SUCCESS: #{transfer.id}"

        # Store success in PayoutLog
        PayoutLog.create!(
          instructor_id: instructor.id,
          course_id: cid,
          amount: earning,
          stripe_transfer_id: transfer.id
        )

        # Add to email list
        payout_items << { course: course, amount: earning }

      rescue Stripe::StripeError => e
        Rails.logger.error "TRANSFER FAILED for Course #{cid}: #{e.message}"

        # Store failure in PayoutLog
        PayoutLog.create!(
          instructor_id: instructor.id,
          course_id: cid,
          amount: earning,
          stripe_transfer_id: nil
        )
      end
    end

    webhook.update(processed: true)
    Rails.logger.info "Webhook #{record_id} marked as processed."

    # --------------------------
    # 3) EMAIL INSTRUCTOR
    # --------------------------
    if payout_items.any?
      instructor = payout_items.first[:course].instructor
      InstructorMailer.payout_success(instructor, payout_items).deliver_later
      
      Rails.logger.info "Email sent to Instructor #{instructor.id}"
    else
      Rails.logger.info "No successful payouts. Email not sent."
    end

    Rails.logger.info "---- PayoutJob END record_id=#{record_id} ----"
  end
end
