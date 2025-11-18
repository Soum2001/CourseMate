module Students
    class EnrollmentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_course, only: [:new, :create]
  
      def new
        # Display enrollment/payment form
      end
  
      def create
        binding.pry
        customer = Stripe::Customer.create(
          email: params[:stripeEmail],
          source: params[:stripeToken]
        )
  
        
        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: (@course.price * 100).to_i, # cents
          description: "Enrollment for #{@course.name}",
          currency: 'usd'
        )
  
        
        Enrollment.create!(
          user: current_user,
          course: @course,
          stripe_customer_id: customer.id,
          stripe_charge_id: charge.id
        )
  
        flash[:notice] = "Enrollment successful!"
        redirect_to students_courses_path
  
      rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_students_enrollment_path(@course)
      end
  
      private
  
      def set_course
        @course = Course.find(params[:course_id])
      end
    end
  end
  