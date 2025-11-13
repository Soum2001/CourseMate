class Instructors::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_instructor

  def show
    @courses = current_user.instructed_courses

  end

  def edit
  end

  def update
  end
  private

  def require_instructor
    redirect_to root_path, alert: "Access denied" unless current_user.roles.exists?(name: "instructor")
  end
end
