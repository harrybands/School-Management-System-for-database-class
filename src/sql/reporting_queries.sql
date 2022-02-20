/* Put your final project reporting queries here */
USE cs_hu_310_final_project;

-- Example (remove before submitting)
-- Get all students
SELECT
    *
FROM students;

-- Calculate the GPA for student given a student_id (use student_id = 1)

select s.first_name, 
s.last_name,
count(cr.student_id) as number_of_classes,
sum(convert_to_grade_point(g.letter_grade)) as total_grade_points_earned,
avg(convert_to_grade_point(g.letter_grade)) as GPA
from students as s
join class_registrations as cr on s.student_id = cr.student_id
join grades as g on cr.grade_id = g.grade_id
where s.student_id = 1
group by s.student_id; 

-- Calculate the GPA for each student (across all classes and all terms)

select s.first_name, 
s.last_name,
count(cr.student_id) as number_of_classes,
sum(convert_to_grade_point(g.letter_grade)) as total_grade_points_earned,
avg(convert_to_grade_point(g.letter_grade)) as GPA
from students as s
join class_registrations as cr on s.student_id = cr.student_id
join grades as g on cr.grade_id = g.grade_id
group by s.student_id;

-- Calculate the avg GPA for each class

select code, name, 
count(cr.grade_id) as number_of_grades, 
sum(convert_to_grade_point(g.letter_grade)) as number_of_grades,
avg(convert_to_grade_point(g.letter_grade)) as 'AVG GPA'
from classes as c 
join class_sections as cs on c.class_id = cs.class_id
join class_registrations as cr on cr.class_section_id = cs.class_section_id
join grades as g on cr.grade_id = g.grade_id 
group by c.class_id;

-- Calculate the avg GPA for each class and term

