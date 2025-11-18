class Students::CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @cart = current_user.cart || current_user.create_cart
  
    course = Course.find(params[:course_id])
    # Prevent adding if already enrolled
    if current_user.enrollments.exists?(course_id: course.id)
      redirect_to student_carts_path, alert: "You are already enrolled!"
      return
    end
  
    # Add course to cart (avoid duplicates)
    cart_item = @cart.cart_items.find_or_create_by(course_id: course.id)

    redirect_to students_carts_path, notice: "Course added to cart!"
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to students_carts_path, notice: "Item removed"
  end
end
