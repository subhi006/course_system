class StudentSignUp < ApplicationRecord
    has_many :enrollments,dependent: :destroy 
    has_many :courses, through: :enrollments

    validates :first_name, :last_name, presence: true, format: { with: /\A[A-Z][a-zA-Z\s]*\z/, message: "must start with a capital letter" }
    validates :phone_number, :gmail, presence: true
    validates :password, confirmation: true, length: { minimum: 8 }
    validate :gmail_only
    
    after_initialize :set_default_login_status
    
    attr_accessor :password_confirmation
    
    def self.login (mail,pass)
        student = StudentSignUp.find_by(gmail: mail)
        if student
            student.login_status ||= true
            student.save
            return student
        else 
            puts "Enter a valid information"
        end
    end


    def logout()
        self.login_status = false
    end
    private

    def gmail_only
        unless gmail =~ /\A[\w+\-.]+@gmail\.com\z/i 
            errors.add(:gmail, "Only Gmail is allowed")
        end 
    end 

    def set_default_login_status
        self.login_status ||= false
    end
end
