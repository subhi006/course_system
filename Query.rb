=begin
1.List all individuals who have signed up on the platform.
-------> StudentSignUp.count
  StudentSignUp Count (4.0ms)  SELECT COUNT(*) FROM "student_sign_ups" /*application='CourseSystem'*/
=> 7

2.Find the total number of courses available.
------->  Course.available.count
  Course Count (1.7ms)  SELECT COUNT(*) FROM "courses" WHERE "courses"."status" = 'open' /*application='CourseSystem'*/
=> 2

3.Retrieve the details of all individuals enrolled in a specific course.
-------> Enrollment.where(course_id: Course.find_by(name: 'MCA').id)
 
Course Load (0.4ms)  SELECT "courses".* FROM "courses" WHERE "courses"."name" = 'MCA' LIMIT 1 /*application='CourseSystem'*/
  Enrollment Load (0.2ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."course_id" = 1 /* loading for pp */ LIMIT 11 /*application='CourseSystem'*/
=>
[#<Enrollment:0x0000017aff242450
  id: 1,
  course_id: 1,
  student_sign_up_id: 1,
  enrollment_date_time: "2000-01-01 21:42:29.286482000 +0000",
  completed_status: "active",
  created_at: "2024-12-29 21:42:29.288979000 +0000",
  updated_at: "2024-12-29 21:42:29.288979000 +0000">]

4.Fetch the names of all courses in which a specific individual is enrolled.
-------> StudentSignUp.find(1).courses.each {|i| p i.name}

  StudentSignUp.find(1).courses.each {|i| p i.name}
  StudentSignUp Load (21.4ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 1 LIMIT 1 /*application='CourseSystem'*/
  Course Load (0.3ms)  SELECT "courses".* FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 1 /*application='CourseSystem'*/
"MA"
"B.Tech."

5.Count how many people are enrolled in each course.
--------> Course.all.each do |i|
             puts "#{i.name} : #{i.student_sign_up.count}"
          end

  Course Load (0.2ms)  SELECT "courses".* FROM "courses" /*application='CourseSystem'*/
  StudentSignUp Count (0.2ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 1 /*application='CourseSystem'*/
MCA : 1
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 2 /*application='CourseSystem'*/
MA : 2
  StudentSignUp Count (0.2ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 3 /*application='CourseSystem'*/
MA.english : 3
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 4 /*application='CourseSystem'*/
B.Tech. : 4
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 5 /*application='CourseSystem'*/
BCA : 0
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 6 /*application='CourseSystem'*/
B.Tech. : 0
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 7 /*application='CourseSystem'*/
BSC.cs : 0

6.Identify the course with the most enrollments.
-------> Course.find(Enrollment.group(:course_id).count.max_by{|key , value| value}.first).name

-12-29 21:25:14.061607000 +0000">]
course-system(dev)> Course.find(Enrollment.group(:course_id).count.max_by{|key , value| value}.first).name
  Enrollment Count (0.2ms)  SELECT COUNT(*) AS "count_all", "enrollments"."course_id" AS "enrollments_course_id" FROM "enrollments" GROUP BY "enrollments"."course_id" /*application='CourseSystem'*/
  Course Load (0.1ms)  SELECT "courses".* FROM "courses" WHERE "courses"."id" = 4 LIMIT 1 /*application='CourseSystem'*/
=> "B.Tech."

7.List all enrollments where the status is marked as "completed."
--------> Enrollment.where( completed_status: "completed").ids

  Enrollment Ids (0.1ms)  SELECT "enrollments"."id" FROM "enrollments" WHERE "enrollments"."completed_status" = 'completed' /*application='CourseSystem'*/
=> [9, 10]

8.Fetch details of individuals who enrolled within the last 7 days.
---------> Enrollment.where("created_at >= ?", 7.days.ago)

9.List all courses that were created within the last month.
--------->  Course.where("created_at >= ?", 1.month.ago).each {|course| p course.name}

  Course Load (0.2ms)  SELECT "courses".* FROM "courses" WHERE (created_at >= '2024-11-30 07:33:11.604137') /*application='CourseSystem'*/
"MA"
"MA.english"
"B.Tech."
"BCA"
"BSC.cs"

10Retrieve the names and enrollment dates of all individuals enrolled in a specific course.
-------->  Course.find_by(name: "MA.english").student_sign_up_ids.each {|i| puts" name: #{StudentSignUp.find(i).first_name} #{StudentSignUp.find(i).last_name} and Enrollment date #{StudentSignUp.find(i).created_at}"}
  
Course Load (0.2ms)  SELECT "courses".* FROM "courses" WHERE "courses"."name" = 'MA.english' LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Pluck (0.1ms)  SELECT "student_sign_ups"."id" FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 3 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 2 LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 2 LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 2 LIMIT 1 /*application='CourseSystem'*/
name: Pranju Jayswal and Enrollment date 2024-12-29 21:38:04 UTC
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 4 LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 4 LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 4 LIMIT 1 /*application='CourseSystem'*/
name: Subhi Mishra and Enrollment date 2024-12-29 21:38:54 UTC
  StudentSignUp Load (0.5ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 5 LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 5 LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 5 LIMIT 1 /*application='CourseSystem'*/
name: Sakshi Mishra and Enrollment date 2024-12-22 21:39:15 UTC
=> [2, 4, 5]

11.Find the names of individuals who have not enrolled in any course.
-------->  StudentSignUp.where.not(id:(Enrollment.group(:student_sign_up_id).count.keys)).each {|student| p "#{student.first_name} #{student.last_name}"}
  
Enrollment Count (0.2ms)  SELECT COUNT(*) AS "count_all", "enrollments"."student_sign_up_id" AS "enrollments_student_sign_up_id" FROM "enrollments" GROUP BY "enrollments"."student_sign_up_id" /*application='CourseSystem'*/
  StudentSignUp Load (0.2ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" NOT IN (1, 2, 4, 5, 6) /*application='CourseSystem'*/

"Mahi Rajput"
"Shivam Barpete"

12.Update the enrollment status of a specific individual to "completed."
--------->a=Enrollment.find(9)
  Enrollment Load (0.2ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."id" = 9 LIMIT 1 /*application='CourseSystem'*/
=>
#<Enrollment:0x0000017a80aa5018
...
course-system(dev)> a.completed_status="completed"
=> "completed"
course-system(dev)> a.save
=> true

13.Remove a specific enrollment from the system.
-------->Enrollment.find(1).delete
  Enrollment Load (0.2ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."id" = 1 LIMIT 1 /*application='CourseSystem'*/
  Enrollment Destroy (3.5ms)  DELETE FROM "enrollments" WHERE "enrollments"."id" = 1 /*application='CourseSystem'*/
=>
#<Enrollment:0x0000017aff328ae0
 id: 1,
 course_id: 1,
 student_sign_up_id: 1,
 enrollment_date_time: "2000-01-01 21:42:29.286482000 +0000",
 completed_status: "active",
 created_at: "2024-12-29 21:42:29.288979000 +0000",
 updated_at: "2024-12-29 21:42:29.288979000 +0000">

14.Retrieve all courses along with the count of their enrollments.
----------> Course.all.each do |i|
---------->   puts "#{i.name} : #{i.student_sign_up.count}"
----------> end

  Course Load (0.2ms)  SELECT "courses".* FROM "courses" /*application='CourseSystem'*/
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 1 /*application='CourseSystem'*/
MCA : 0
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 2 /*application='CourseSystem'*/
MA : 2
  StudentSignUp Count (0.2ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 3 /*application='CourseSystem'*/
MA.english : 3
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 4 /*application='CourseSystem'*/
B.Tech. : 4
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 5 /*application='CourseSystem'*/
BCA : 0
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 6 /*application='CourseSystem'*/
B.Tech. : 0
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 7 /*application='CourseSystem'*/
BSC.cs : 0

15.Identify individuals who are enrolled in more than three courses.
----------> > StudentSignUp.all.each{|i| p i.first_name if i.courses.count>3}

  StudentSignUp Load (0.8ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" /*application='CourseSystem'*/
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 1 /*application='CourseSystem'*/
"Pranju"

16.Find courses that have fewer than five enrollments.
----------> Course.all.each{|i| p i.name if i.student_sign_up.count<5}

  Course Load (0.2ms)  SELECT "courses".* FROM "courses" /*application='CourseSystem'*/
  StudentSignUp Count (0.2ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 1 /*application='CourseSystem'*/
"MCA"
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 2 /*application='CourseSystem'*/
"MA"
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 3 /*application='CourseSystem'*/
"MA.english"
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 4 /*application='CourseSystem'*/
"B.Tech."
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 5 /*application='CourseSystem'*/
"BCA"
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 6 /*application='CourseSystem'*/
"B.Tech."
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 7 /*application='CourseSystem'*/
"BSC.cs"

17.List all individuals who have enrolled in multiple courses.
----------> StudentSignUp.all.each{|i| p i.first_name if i.courses.count>1
StudentSignUp.all.each{|i| p i.first_name if i.courses.count>1}
  StudentSignUp Load (0.2ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" /*application='CourseSystem'*/
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 1 /*application='CourseSystem'*/
"Pranju"
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 2 /*application='CourseSystem'*/
"Pranju"
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 3 /*application='CourseSystem'*/
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 4 /*application='CourseSystem'*/
"Subhi"
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 5 /*application='CourseSystem'*/
"Sakshi"
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 6 /*application='CourseSystem'*/
  Course Count (0.1ms)  SELECT COUNT(*) FROM "courses" INNER JOIN "enrollments" ON "courses"."id" = "enrollments"."course_id" WHERE "enrollments"."student_sign_up_id" = 7 /*application='CourseSystem'*/

18.Fetch the latest enrollment for each individual.
-------->a={}
course-system(dev)> StudentSignUp.all.each{|i| p a[i.first_name]=i.enrollment_ids.last}
a.compact!
=> {"Pranju"=>4, "Subhi"=>10, "Sakshi"=>7, "Shaloni"=>8}
course-system(dev)* a.each do |key,value|
course-system(dev)*   puts "#{key} last enrollment is #{value}"
course-system(dev)> end
Pranju last enrollment is 4
Subhi last enrollment is 10
Sakshi last enrollment is 7
Shaloni last enrollment is 8

19.Retrieve all courses sorted by the number of enrollments in descending order.
----------> b={}
=> {}
---------> Course.all.each do |i|
--------->    b[i.name]=i.student_sign_up.count
--------->  end
 ---------> b.sort.reverse.each {|i|p i.first}
"MCA"
"MA.english"
"MA"
"BSC.cs"
"BCA"
"B.Tech."
20.Find the average number of enrollments per course.
------->

21.Fetch the total number of enrollments on the platform.
-------->

22.Retrieve the details of the individual who has been enrolled the longest in a specific course.
--------> a=Enrollment.where(course_id: 2).where(completed_status: 'active').order(:created_at).first
 
Enrollment Load (0.4ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."course_id" = 2 AND "enrollments"."completed_status" = 'active' ORDER BY "enrollments"."created_at" ASC LIMIT 1 /*application='CourseSystem'*/
=>
#<Enrollment:0x0000017aff003d60
...
course-system(dev)> "#{a.student_sign_up.first_name} is longest enrolled #{a.course.name} "
  StudentSignUp Load (0.2ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 1 LIMIT 1 /*application='CourseSystem'*/
  Course Load (0.1ms)  SELECT "courses".* FROM "courses" WHERE "courses"."id" = 2 LIMIT 1 /*application='CourseSystem'*/
=> "Pranju is longest enrolled MA "


23.List all enrollments where the status is "dropped."
-------->  Enrollment.where(completed_status: 'dropped').ids

  Enrollment Ids (0.2ms)  SELECT "enrollments"."id" FROM "enrollments" WHERE "enrollments"."completed_status" = 'dropped' /*application='CourseSystem'*/
=> [4, 5, 6, 7, 8]

24.Identify courses that no one has enrolled in.
--------> Course.all.each{|i| p i.name if i.student_sign_up.count<1}

 StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 6 /*application='CourseSystem'*/
"B.Tech."
  StudentSignUp Count (0.1ms)  SELECT COUNT(*) FROM "student_sign_ups" INNER JOIN "enrollments" ON "student_sign_ups"."id" = "enrollments"."student_sign_up_id" WHERE "enrollments"."course_id" = 7 /*application='CourseSystem'*/
"BSC.cs"


25.Find the top five individuals with the most enrollments.
---------->  Enrollment.group(:student_sign_up).order('COUNT(student_sign_up_id) DESC').limit(5).count.keys.each { |i| p "#{i.first_name} #{i.last_name}"}

  Enrollment Count (0.3ms)  SELECT COUNT(*) AS "count_all", "enrollments"."student_sign_up_id" AS "enrollments_student_sign_up_id" FROM "enrollments" GROUP BY "enrollments"."student_sign_up_id" ORDER BY COUNT(student_sign_up_id) DESC LIMIT 5 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" IN (1, 2, 4, 5, 6) /*application='CourseSystem'*/
"Pranju Jayswal"
"Pranju Jayswal"
"Subhi Mishra"
"Sakshi Mishra"
"Shaloni Mishra"

26.Retrieve the most recently created course.
---------> A=Course.all
  Course Load (0.2ms)  SELECT "courses".* FROM "courses" /* loading for pp */ LIMIT 11 /*application='CourseSystem'*/
=>
[#<Course:0x0000017a80aac1d8
...
---------> A. sort_by{|item| item.created_at}.last.name

  Course Load (0.5ms)  SELECT "courses".* FROM "courses" /*application='CourseSystem'*/
=> "BCA"
course-system(dev)>


27.Find the individual with the highest number of completed enrollments.
----------->StudentSignUp.find_by(id:Enrollment.group(:student_sign_up_id).where(completed_status: 'completed').count.max_by{|key , value| value}.first).first_name
  Enrollment Count (0.2ms)  SELECT COUNT(*) AS "count_all", "enrollments"."student_sign_up_id" AS "enrollments_student_sign_up_id" FROM "enrollments" WHERE "enrollments"."completed_status" = 'completed' GROUP BY "enrollments"."student_sign_up_id" /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 1 LIMIT 1 /*application='CourseSystem'*/
=> "Pranju"


28Fetch all courses and include the names of individuals enrolled in each course.
----------->


29.List all enrollments for individuals who signed up within the last month.
--------->StudentSignUp.where("created_at > ?", 1.month.ago)


30.Identify all individuals who are currently enrolled in at least one course.
 a=Enrollment.distinct.pluck(:student_sign_up_id).each do |i|
course-system(dev)*   puts StudentSignUp.find(i).first_name
course-system(dev)> end
  Enrollment Pluck (0.2ms)  SELECT DISTINCT "enrollments"."student_sign_up_id" FROM "enrollments" /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 1 LIMIT 1 /*application='CourseSystem'*/
Pranju
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 2 LIMIT 1 /*application='CourseSystem'*/
Pranju
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 4 LIMIT 1 /*application='CourseSystem'*/
Subhi
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 5 LIMIT 1 /*application='CourseSystem'*/
Sakshi
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 6 LIMIT 1 /*application='CourseSystem'*/
Shaloni

31.Retrieve the names of all courses where enrollment is still open.
-----------> Course.where(status: 'open')
  Course Load (0.2ms)  SELECT "courses".* FROM "courses" WHERE "courses"."status" = 'open' /* loading for pp */ LIMIT 11 /*application='CourseSystem'*/
=>
[#<Course:0x0000017aff247a90
  id: 1,
  name: "MCA",
  description: "new",
  price: 0.3e4,
  duration: 2,
  status: "open",
  created_at: "2024-12-29 21:22:40.501627000 +0000",
  updated_at: "2024-12-29 21:22:40.501627000 +0000">,
 #<Course:0x0000017aff247950
  id: 2,
  name: "MA",
  description: "new",
  price: 0.2e4,
  duration: 2,
  status: "open",
  created_at: "2024-12-29 21:23:03.693699000 +0000",
  updated_at: "2024-12-29 21:23:03.693699000 +0000">]

32.Count how many individuals have completed at least one course.
----------->


33.Retrieve the total number of enrollments for a specific individual.
----------->  

35Find individuals who enrolled in a specific course on a specific date.
-----------> 
36.Update the name of a specific course.
-----------> Course.find(1).update(name: 'MCA-1')
37Delete a specific course from the system.
----------->  Course.find(1).destroy
  Course Load (0.2ms)  SELECT "courses".* FROM "courses" WHERE "courses"."id" = 1 LIMIT 1 /*application='CourseSystem'*/
  TRANSACTION (0.1ms)  BEGIN immediate TRANSACTION /*application='CourseSystem'*/
  Enrollment Load (0.4ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."course_id" = 1 /*application='CourseSystem'*/
  Course Destroy (0.3ms)  DELETE FROM "courses" WHERE "courses"."id" = 1 /*application='CourseSystem'*/
  TRANSACTION (0.2ms)  COMMIT TRANSACTION /*application='CourseSystem'*/

38.Retrieve all courses along with the average duration of enrollments.
----------->
39.Fetch the details of enrollments that were updated in the last 24 hours.
----------->

40.Identify individuals who have dropped out of multiple courses.
-----------> p StudentSignUp.find(student_id).first_name
course-system(dev)> end
  Enrollment Count (0.1ms)  SELECT COUNT(*) AS "count_all", "enrollments"."student_sign_up_id" AS "enrollments_student_sign_up_id" FROM "enrollments" WHERE "enrollments"."completed_status" = 'dropped' GROUP BY "enrollments"."student_sign_up_id" HAVING (COUNT(course_id) > 1) /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 5 LIMIT 1 /*application='CourseSystem'*/
"Sakshi"
=> [5]

41.Retrieve the count of courses where enrollment is marked as "active."
----------->
42.List all courses sorted alphabetically by name.
-----------> Course.order(:name).each do |i|
course-system(dev)*   p i.name
course-system(dev)> end
  Course Load (0.2ms)  SELECT "courses".* FROM "courses" ORDER BY "courses"."name" ASC /*application='CourseSystem'*/
"B.Tech."
"B.Tech."
"BCA"
"BSC.cs"
"MA"
"MA.english"

43.Find the total number of individuals who signed up on the platform.
-----------> StudentSignUp.count
=> 7

44.Retrieve the most popular course based on enrollment numbers.
----------->  


#<Course:0x0000017a80acfa20
 id: 4,
 name: "B.Tech.",
 description: "new",
 price: 0.2e5,
 duration: 4,
 status: "close",
 created_at: "2024-12-29 21:23:46.013351000 +0000",
 updated_at: "2024-12-29 21:23:46.013351000 +0000">


45.Fetch all courses where the average enrollment duration exceeds a given value.
---------->

46.Identify individuals who enrolled in courses but never completed any.
---------->

47.Retrieve all enrollments sorted by enrollment date in descending order.
--------->Enrollment.order(created_at: :desc)


48.Count the number of enrollments where the status is "active."
-----------> Enrollment.where(status: 'active').count

49.Find individuals who have not updated their enrollment status in over a month.
----------->Enrollment.where("updated_at < ?", 1.month.ago)

50Retrieve the list of all courses, including the total duration of all enrollments.
-----------> 

53Fetch the oldest enrollment record for each course.
 Course.all.each do |course|
   old = course.enrollments.order(:created_at).first
   puts " #{course.name} : #{old.student_sign_up.first_name}" if old
 end

  Course Load (0.2ms)  SELECT "courses".* FROM "courses" /*application='CourseSystem'*/
  Enrollment Load (0.1ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."course_id" = 2 ORDER BY "enrollments"."created_at" ASC LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 1 LIMIT 1 /*application='CourseSystem'*/
 MA : Pranju
  Enrollment Load (0.1ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."course_id" = 3 ORDER BY "enrollments"."created_at" ASC LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.1ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 2 LIMIT 1 /*application='CourseSystem'*/
 MA.english : Pranju
  Enrollment Load (0.1ms)  SELECT "enrollments".* FROM "enrollments" WHERE "enrollments"."course_id" = 4 ORDER BY "enrollments"."created_at" ASC LIMIT 1 /*application='CourseSystem'*/
  StudentSignUp Load (0.2ms)  SELECT "student_sign_ups".* FROM "student_sign_ups" WHERE "student_sign_ups"."id" = 5 LIMIT 1 /*application='CourseSystem'*/
 B.Tech. : Sakshi
 
=end