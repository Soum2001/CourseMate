class Students::CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = current_user.cart || current_user.create_cart
    @courses = @cart.courses
  end

  
  def destroy
  end

  def show
  end
end
