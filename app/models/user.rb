class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: [:google_oauth2]

    has_many :enrollments
    has_many :enrolled_courses, through: :enrollments,source: :course
    has_many :instructed_courses, class_name: 'Course', foreign_key: 'instructor_id'
    has_many :user_roles
    has_many :roles, through: :user_roles
    has_one :cart, dependent: :destroy

    def self.from_omniauth(auth)

      user = where(provider: auth.provider, uid: auth.uid).first
    
      if user.nil?
        user = create(
          provider: auth.provider,
          uid: auth.uid,
          email: auth.info.email,
          name: auth.info.name,
          password: Devise.friendly_token[0, 20]
        )
  
      end
    
      # Always assign student role if missing
      student_role = Role.find_by(name: 'student')
      if student_role.present? && !user.roles.exists?(name: 'student')
  
        UserRole.create(user_id: user.id, role_id: student_role.id)
      end
    
      user
    end
    
end
    