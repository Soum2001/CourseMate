module Instructors
  class CoursesController < ApplicationController
      before_action :set_course, only: [:show, :edit, :update, :destroy]
      before_action :authenticate_user!

      def index
        @courses = current_user.instructed_courses
        
      end
    
      def show
      end
    
      def new
        @course = Course.new
      end
    
      def create
        @course = Course.new(course_params)
        @course.instructor_id = current_user.id  # assuming instructor creates course
        if @course.save
          binding.pry
          redirect_to instructors_courses_path, notice: "Course was successfully created."
        else
          render :new
        end
      end
    
      def edit
      end
    
      def update
        if @course.update(course_params)
          redirect_to instructors_courses_path, notice: "Course was successfully updated."
        else
          render :edit
        end
      end
    
      def destroy
        @course.destroy
        redirect_to root_path, notice: "Course was successfully deleted."
      end
    
      private
    
      def set_course
        @course = Course.find(params[:id])
      end
    
      def course_params
        params.require(:course).permit(:title, :description, :video_url)
      end
  end
end
