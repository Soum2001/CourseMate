class PayoutJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    
    webhook = Webhook.find_by(id: record_id)
    return if webhook.processed?

    data = JSON.parse(webhook.payload)
    pi = data["data"]["object"]

    user_id     = pi["metadata"]["user_id"]
    course_ids  = JSON.parse(pi["metadata"]["course_ids"])

    # 1. ENROLL USER
    user = User.find(user_id)
    course_ids.each do |cid|
      Enrollment.find_or_create_by(
        user_id: user.id,
        course_id: cid
      )
    end
    
    # 2. PAYOUT TO INSTRUCTORS
    course_ids.each do |cid|
      course = Course.find(cid)
      instructor = course.instructor

      earning = course.amount

      transfer = Stripe::Transfer.create({
        amount: (earning * 1).to_i,
        currency: "usd",
        destination: instructor.stripe_account_id,
        transfer_group: "course_#{cid}"
      })

      PayoutLog.create!(
        instructor_id: instructor.id,
        course_id: cid,
        amount: earning,
        stripe_transfer_id: transfer.id
      )
    end

    webhook.update(processed: true)
  end
end
