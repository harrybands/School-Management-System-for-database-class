CREATE DATABASE IF NOT EXISTS cs_hu_310_final_project;
USE cs_hu_310_final_project;
DROP TABLE IF EXISTS class_registrations;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS class_sections;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS academic_titles;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS classes
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
)

