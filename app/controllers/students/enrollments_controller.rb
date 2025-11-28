module Students
    class EnrollmentsController < ApplicationController
      before_action :authenticate_user!


      def show
        @courses = current_user.courses
      end
    end
  end

  