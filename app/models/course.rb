class Course < ApplicationRecord
    has_many :enrollments,dependent: :destroy
    has_many :student_sign_up, through: :enrollments
    validates :name,:price,:duration,:status, presence: true 

    def self.available()
        course = Course.where(status: 'open')
        return course
    end

    # enum status: { open: 0, close: 1 }
end
