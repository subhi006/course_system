class CreateStudentSignUps < ActiveRecord::Migration[8.0]
  def change
    create_table :student_sign_ups do |t|
      t.string :first_name
      t.string :last_name
      t.string :gmail
      t.string :phone_number
      t.string :password
      t.boolean :login_status
      t.timestamps
    end
  end
end
