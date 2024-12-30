class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.references :course, null: false, foreign_key: true
      t.references :student_sign_up, null: false, foreign_key: true
      t.time :enrollment_date_time
      t.string :completed_status
      t.timestamps 
    end
  end
end
