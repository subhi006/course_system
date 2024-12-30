class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :name 
      t.string :description
      t.decimal :price
      t.integer :duration
      t.string :status 
      # t.string :course_status
      t.timestamps
    end
  end
end
