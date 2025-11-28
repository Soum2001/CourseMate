class Students::CheckoutsController < ApplicationController
  before_action :authenticate_user!
  def create
    begin
      courses = Course.where(id: params[:course_ids])
      course_ids_json = courses.pluck(:id).to_json
        line_items = courses.map do |course|
          {
            "price_data" => {
              "currency" => "inr",
              "product_data" => { "name" => course.title },
              "unit_amount" => (course.amount.to_i * 100 * 50)
            },
            "quantity" => 1
          }
        end
       
        session = Stripe::Checkout::Session.create(
          payment_method_types: ["card"],
          line_items: line_items,
          mode: "payment",
          payment_intent_data: {
            metadata: {
              course_ids: course_ids_json,    
              user_id: current_user.id        
            }
          },         
          customer_creation: "always",
          billing_address_collection: "required",  
          success_url: students_enrollment_url,
          cancel_url: students_carts_url
        )
        render json: { id: session.id }
        
      rescue => e
        Rails.logger.error "CHECKOUT ERROR: #{e.full_message}"
        render json: { error: e.message }, status: 422
      end
  end

  def success

  end
  

  def show
  end
end
