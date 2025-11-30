class InstructorMailer < ApplicationMailer
  
    def payout_success(instructor, payout_items)
      @instructor = instructor
      @payout_items = payout_items     # array of { course:, amount: }
        
      @total_amount = payout_items.sum { |i| i[:amount] }
    
      mail(
        to: instructor.email,
        subject: "You received a payout of $#{@total_amount}"
      )
    end
  end
  