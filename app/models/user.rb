class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: [:google_oauth2]

    has_many :enrollments
    has_many :courses, through: :enrollments
    has_many :instructed_courses, class_name: 'Course', foreign_key: 'instructor_id'
    has_many :user_roles
    has_many :roles, through: :user_roles

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
       # Assign student role after OAuth login if not already assigned
      student_role = Role.find_by(name: 'student')
      if student_role.present? && !user.roles.exists?(name: 'student')
        UserRole.create(user_id: user.id, role_id: student_role.id, student_id: user.id)
      end
    end
  end
end
    