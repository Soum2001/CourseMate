module Students
  class CoursesController < ApplicationController
      before_action :set_course, only: [:show, :edit, :update, :destroy]
      before_action :authenticate_user!


      def index
        # LEVEL filter 
        @courses = Course.where.not(instructor_id: current_user.id)
        if params[:level].present?
          level = Level.find_by(name: params[:level])
          @courses = @courses.where(level_id: level.id) if level
        end
       
        # TOPIC filter using SQL LIKE
        if params[:topic].present?
          keyword = params[:topic].downcase.strip
          @courses = @courses.where("LOWER(title) LIKE ?", "%#{keyword}%")
         
        end
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
