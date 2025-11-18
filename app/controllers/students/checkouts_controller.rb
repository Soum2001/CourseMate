class Students::CheckoutsController < ApplicationController
  before_action :authenticate_user!
  def create
    begin
      courses = Course.where(id: params[:course_ids])

      line_items = courses.map do |course|
        {
          "price_data" => {
            "currency" => "inr",
            "product_data" => { "name" => course.title },
            "unit_amount" => (course.amount.to_i * 100)
          },
          "quantity" => 1
        }
      end
      binding.pry
      session = Stripe::Checkout::Session.create(
        payment_method_types: ["card"],
        line_items: line_items,
        mode: "payment",
        success_url: "#{root_url}students/checkouts/success?course_ids=#{courses.pluck(:id).join(',')}",
        cancel_url: "#{root_url}students/cart"
      )

      render json: { id: session.id }

    rescue => e
      render json: { error: e.message }, status: 422
    end
  end

  def success
    course_ids = params[:course_ids].split(",")

    course_ids.each do |cid|
      Enrollment.find_or_create_by(user_id: current_user.id, course_id: cid)
    end

    redirect_to students_courses_path, notice: "Payment successful!"
  end

  def success
  end
end
