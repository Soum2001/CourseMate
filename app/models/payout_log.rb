class PayoutLog < ApplicationRecord
    belongs_to :instructor, class_name: "User", foreign_key: :instructor_id
    belongs_to :course
  
    validates :amount, presence: true
    validates :stripe_transfer_id, presence: true
end
