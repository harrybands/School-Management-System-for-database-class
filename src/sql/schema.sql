CREATE DATABASE IF NOT EXISTS cs_hu_310_final_project;
USE cs_hu_310_final_project;
DROP TABLE IF EXISTS class_registrations;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS class_sections;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS academic_titles;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS classes;
DROP FUNCTION IF EXISTS convert_to_grade_point;
CREATE TABLE IF NOT EXISTS classes(
 class_id INT AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL,
 description VARCHAR(1000),
 code VARCHAR(10) UNIQUE,
 maximum_students INT DEFAULT 10,
 PRIMARY KEY(class_id)
);
CREATE TABLE IF NOT EXISTS students(
 student_id INT AUTO_INCREMENT,
 first_name VARCHAR(30) NOT NULL,
 last_name VARCHAR(50) NOT NULL,
 birthdate DATE,
 PRIMARY KEY (student_id)
);
create table academics_titles(
	academic_title_id int auto_increment not null, 
    title varchar(255) not null,
	primary key(academic_title_id)
    );
create table instructors(
instructor_id int auto_increment not null, 
first_name varchar(80) not null,
last_name varchar(80) not null,
academic_title_id int,
primary key(instructor_id),
foreign key(academic_title_id) references academics_titles(academic_title_id)
); 
create table terms(
term_id int auto_increment not null, 
name varchar(80) not null,
primary key(term_id)
);

create table class_sections(
class_section_id int auto_increment,
class_id int not null,
instructor_id int not null, 
term_id int not null, 
primary key(class_section_id),
foreign key(class_id) references classes(class_id), 
foreign key(instructor_id) references instructors(instructor_id), 
foreign key(term_id) references terms(term_id)
);

create table grades(
grade_id int auto_increment not null,
letter_grade char(2) not null, 
primary key(grade_id)
);

create table class_registrations(
class_section_id int not null,
class_registration_id int auto_increment not null,
student_id int, 
grade_id int, 
signup_timestamp datetime default current_timestamp,
foreign key(class_section_id) references class_sections(class_section_id), 
primary key(class_registration_id)
);

DELIMITER $$
CREATE FUNCTION convert_to_grade_point(letter_grade char(2))
 RETURNS char
 DETERMINISTIC
BEGIN
 declare grade_point int; 
 if letter_grade = 'A' then
	set grade_point = 4; 
elseif letter_grade = 'B' then 
	set grade_point = 3; 
elseif letter_grade = 'C' then 
	set grade_point = 2; 
elseif letter_grade = 'D' then 
	set grade_point = 1; 
elseif letter_grade = 'F' then 
	set grade_point = 0;
else
	set grade_point = null; 
end if;
return grade_point; 
END $$

-- 1. Calculate the GPA for student given a student_id (use student_id=1)

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

-- 2. Calculate the GPA for each student (across all classes and all terms)

select s.first_name, 
s.last_name,
count(cr.student_id) as number_of_classes,
sum(convert_to_grade_point(g.letter_grade)) as total_grade_points_earned,
avg(convert_to_grade_point(g.letter_grade)) as GPA
from students as s
join class_registrations as cr on s.student_id = cr.student_id
join grades as g on cr.grade_id = g.grade_id
-- where s.student_id = 1
group by s.student_id; 

-- 3. Calculate the avg GPA for each class

select c.code, c.name, 
count(cr.grade_id) as number_of_grades, 
sum(convert_to_grade_point(g.letter_grade)) as total_of_grades,
avg(convert_to_grade_point(g.letter_grade)) as 'AVG GPA'
from classes as c 
join class_sections as cs on c.class_id = cs.class_id
join class_registrations as cr on cr.class_section_id = cs.class_section_id
join grades as g on cr.grade_id = g.grade_id 
group by c.class_id;

-- 4. Calculate the avg GPA for each class and term


select c.code, c.name, t.name as term,
count(cr.grade_id) as number_of_grades,
sum(convert_to_grade_point(g.letter_grade)) as total_of_grades,
avg(convert_to_grade_point(g.letter_grade)) as 'AVG GPA'
from class_sections as cs
left join classes as c on c.class_id = cs.class_id
left join terms as t on cs.term_id = t.term_id
left join class_registrations as cr on cs.class_section_id = cr.class_section_id
left join grades as g on cr.grade_id = g.grade_id
group by c.code, c.name, t.name

-- 5. List all the classes being taught by an instructor (use instructor_id=1)

SELECT instructors.first_name, instructors.last_name, academic_titles.title, classes.code, classes.name AS class_name, terms.name AS term
FROM class_sections
LEFT JOIN classes ON class_sections.class_id = classes.class_id
LEFT JOIN instructors ON class_sections.instructor_id = instructors.instructor_id
LEFT JOIN terms ON class_sections.term_id = terms.term_id
LEFT JOIN academic_titles ON instructors.academic_title_id = academic_titles.academic_title_id
WHERE class_sections.instructor_id = 1;

-- 6. List all classes with terms & instructor

select c.code, c.name, 
t.name as term,
first_name, last_name
from class_sections as cs
join classes as c on cs.class_id = cs.instructor_id
join instructors as i on cs.class_id = i.instructor_id
join terms as t on cs.term_id = t.term_id
join academic_titles as att on i.academic_title_id= att.academic_title_id

-- 7. Calculate the remaining space left in a class

select c.code, c.name, t.name as term,
count(cr.student_id) as enrolled_students,
c.maximum_students - count(cr.student_id)
from class_sections as cs
join classes as c on c.class_id = cs.class_id
join terms as t on cs.term_id = t.term_id
join class_registrations as cr on cs.class_section_id = cr.class_section_id
left join grades as g on cr.grade_id = g.grade_id
group by c.code, c.name, t.name, c.maximum_students

