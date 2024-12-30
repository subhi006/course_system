# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_29_211401) do
  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "price"
    t.integer "duration"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "student_sign_up_id", null: false
    t.time "enrollment_date_time"
    t.string "completed_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["student_sign_up_id"], name: "index_enrollments_on_student_sign_up_id"
  end

  create_table "student_sign_ups", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gmail"
    t.string "phone_number"
    t.string "password"
    t.boolean "login_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "student_sign_ups"
end
