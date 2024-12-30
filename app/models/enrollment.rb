class Enrollment < ApplicationRecord
    belongs_to :student_sign_up
     belongs_to :course

   validates :completed_status,presence:true
   


   def self.popular_course()
       arr=[]
       Enrollment.all.each{|i| arr.append(i.course_id)}
       return Course.find(arr.max).name
   end
#    enum :completed_status, [:active,:dropped,:completed]
end
