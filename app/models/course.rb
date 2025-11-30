class Course < ApplicationRecord
    belongs_to :instructor, class_name: 'User'
    has_many :enrollments, dependent: :destroy
    has_many :students, through: :enrollments, source: :user
    belongs_to :category
    belongs_to :level
    
    validates :title, :description, :amount, presence: true
    validates :amount, numericality: { greater_than_or_equal_to: 0 }
  
end
