module Students
    class EnrollmentsController < ApplicationController
      before_action :authenticate_user!


      # def show
      #   @courses = current_user.courses
      #   binding.pry
      # end
      def index
        @courses = current_user.enrolled_courses
        binding.pry
      end
    end
  end

  