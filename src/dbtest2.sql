-- faculty (Khoa trong tr??ng)
create table faculty (
	id number primary key,
	name nvarchar2(30) not null
);

-- subject (Môn h?c)
create table subject(
	id number primary key,
	name nvarchar2(100) not null,
	lesson_quantity number(2,0) not null -- t?ng s? ti?t h?c
);

-- student (Sinh viên)
create table student (
	id number primary key,
	name nvarchar2(30) not null,
	gender nvarchar2(10) not null, -- gi?i tính
	birthday date not null,
	hometown nvarchar2(100) not null, -- quê quán
	scholarship number, -- h?c b?ng
	faculty_id number not null constraint faculty_id references faculty(id) -- mã khoa
);

-- exam management (B?ng ?i?m)
create table exam_management(
	id number primary key,
	student_id number not null constraint student_id references student(id),
	subject_id number not null constraint subject_id references subject(id),
	number_of_exam_taking number not null, -- s? l?n thi (thi trên 1 l?n ???c g?i là thi l?i) 
	mark number(4,2) not null -- ?i?m
);
-- subject
insert into subject (id, name, lesson_quantity) values (1, n'C? s? d? li?u', 45);
insert into subject values (2, n'Trí tu? nhân t?o', 45);
insert into subject values (3, n'Truy?n tin', 45);
insert into subject values (4, n'?? h?a', 60);
insert into subject values (5, n'V?n ph?m', 45);


-- faculty
insert into faculty values (1, n'Anh - V?n');
insert into faculty values (2, n'Tin h?c');
insert into faculty values (3, n'Tri?t h?c');
insert into faculty values (4, n'V?t lý');


-- student
insert into student values (1, n'Nguy?n Th? H?i', n'N?', to_date('19900223', 'YYYYMMDD'), 'Hà N?i', 130000, 2);
insert into student values (2, n'Tr?n V?n Chính', n'Nam', to_date('19921224', 'YYYYMMDD'), 'Bình ??nh', 150000, 4);
insert into student values (3, n'Lê Thu Y?n', n'N?', to_date('19900221', 'YYYYMMDD'), 'TP HCM', 150000, 2);
insert into student values (4, n'Lê H?i Y?n', n'N?', to_date('19900221', 'YYYYMMDD'), 'TP HCM', 170000, 2);
insert into student values (5, n'Tr?n Anh Tu?n', n'Nam', to_date('19901220', 'YYYYMMDD'), 'Hà N?i', 180000, 1);
insert into student values (6, n'Tr?n Thanh Mai', n'N?', to_date('19910812', 'YYYYMMDD'), 'H?i Phòng', null, 3);
insert into student values (7, n'Tr?n Th? Thu Th?y', n'N?', to_date('19910102', 'YYYYMMDD'), 'H?i Phòng', 10000, 1);


-- exam_management
insert into exam_management values (1, 1, 1, 1, 3);
insert into exam_management values (2, 1, 1, 2, 6);
insert into exam_management values (3, 1, 2, 2, 6);
insert into exam_management values (4, 1, 3, 1, 5);
insert into exam_management values (5, 2, 1, 1, 4.5);
insert into exam_management values (6, 2, 1, 2, 7);
insert into exam_management values (7, 2, 3, 1, 10);
insert into exam_management values (8, 2, 5, 1, 9);
insert into exam_management values (9, 3, 1, 1, 2);
insert into exam_management values (10, 3, 1, 2, 5);
insert into exam_management values (11, 3, 3, 1, 2.5);
insert into exam_management values (12, 3, 3, 2, 4);
insert into exam_management values (13, 4, 5, 2, 10);
insert into exam_management values (14, 5, 1, 1, 7);
insert into exam_management values (15, 5, 3, 1, 2.5);
insert into exam_management values (16, 5, 3, 2, 5);
insert into exam_management values (17, 6, 2, 1, 6);
insert into exam_management values (18, 6, 4, 1, 10);


/********* A. BASIC QUERY *********/

--1--
SELECT * FROM student
ORDER BY id ASC;
SELECT * FROM student
ORDER BY gender;
SELECT * FROM student
ORDER BY  birthday ASC,scholarship DESC; 
--2--
SELECT name FROM subject
WHERE name LIKE ('T%');
--3--
SELECT name FROM student
WHERE name LIKE ('%i');
--4--
SELECT name FROM faculty
WHERE name LIKE ('_n%');
--5--
SELECT name FROM student
WHERE name LIKE '%Th?%';
--6--
SELECT name FROM student
WHERE name BETWEEN 'A' AND 'M'
ORDER BY name ;
--7--
SELECT scholarship FROM student
WHERE scholarship > 100000
ORDER BY faculty_id DESC;
--8--
SELECT scholarship, hometown FROM student
WHERE scholarship > 150000 AND hometown = 'Hà N?i';
--9--
SELECT * FROM student
WHERE birthday BETWEEN TO_DATE('01/01/1991','DD/MM/YYYY') AND TO_DATE('05/06/1992','DD/MM/YYYY');
--10--
SELECT * FROM student
WHERE scholarship BETWEEN 80000 AND 150000;
--11--
SELECT * FROM subject
where lesson_quantity >30 AND subject.lesson_quantity < 45;
-------------------------------------------------------------------

/********* B. CALCULATION QUERY *********/

--1--
SELECT id, gender, faculty_id, 
CASE WHEN scholarship > 500000 THEN 'H?c b?ng cao' ELSE 'H?c b?ng trung bình' END scholarship
from student;
--2--
SELECT COUNT(id) AS total_students
FROM student;
--3--
SELECT gender, COUNT(id)
FROM student
GROUP BY gender;
--4--
SELECT faculty.name, COUNT(student.id) 
FROM student,faculty 
WHERE student.faculty_id = faculty.id 
GROUP BY faculty.name;
--5--
SELECT subject.name, COUNT(exam_management.student_id) 
FROM exam_management, subject 
WHERE subject.id = exam_management.subject_id 
GROUP BY subject.name;
--6--
SELECT student_id, COUNT(subject_id) 
FROM exam_management 
GROUP BY student_id;
--7--
SELECT faculty.name, COUNT(student.scholarship)
FROM faculty, student
WHERE faculty.id = student.faculty_id
GROUP BY faculty.name;
--8--
SELECT faculty.name, MAX(student.scholarship)
FROM faculty, student
WHERE faculty.id = student.id
GROUP BY faculty.name;
--9--
SELECT faculty.name, gender, COUNT(student.id) soSV
FROM student, faculty
WHERE faculty.id = student.faculty_id AND gender = 'Nam'
GROUP BY faculty.name, gender
UNION
SELECT faculty.name, gender, COUNT(student.id) soSV
FROM student, faculty
WHERE faculty.id = student.faculty_id AND gender = 'N?'
GROUP BY faculty.name, gender;
--10--
SELECT student.birthday, COUNT(student.id) AS soSV
FROM student
GROUP BY student.birthday;
--11--
SELECT student.hometown, COUNT(student.id) as total 
FROM student 
GROUP BY hometown 
HAVING COUNT(student.id) > 2;
--12--
--SELECT * FROM exam_management;
SELECT student.name,  COUNT(exam_management.number_of_exam_taking) AS soLanThiLai
FROM student, exam_management
WHERE exam_management.student_id = student.id
GROUP BY student.name
HAVING COUNT(exam_management.number_of_exam_taking) >= 2;
--13--
SELECT student.name, AVG(exam_management.mark)
FROM student, exam_management
WHERE student.gender = 'Nam' AND student.id = exam_management.student_id AND exam_management.number_of_exam_taking = 1
GROUP BY student.name
HAVING AVG(exam_management.mark) > 7;
--14--
SELECT student.name 
FROM student, exam_management
WHERE exam_management.number_of_exam_taking = 1 and exam_management.mark <= 4 and student.id = exam_management.student_id 
GROUP BY student.name;
--15--
SELECT faculty.name
FROM faculty, student
WHERE student.gender = 'Nam' AND student.faculty_id = faculty.id
GROUP BY faculty.name
HAVING COUNT(student.gender) > 2;
--16--
SELECT faculty.name
FROM faculty, student
WHERE faculty.id = student.faculty_id AND student.scholarship BETWEEN 20000 AND 30000
GROUP BY faculty.name
HAVING COUNT(student.id)= 2;
--17--
SELECT student.name, MAX(student.scholarship) AS hocBongCaoNhat
FROM student
WHERE student.scholarship = (SELECT MAX(student.scholarship) FROM student)
GROUP BY student.name;

/********* C. DATE/TIME QUERY *********/
--1--
SELECT student.name 
FROM student 
WHERE TO_CHAR(birthday,'MM')='02' AND student.hometown = 'Hà N?i';
--2--
--select student.name, current_year - to_number(to_char(student.birthday, 'YYYY')) age
--from student --ch? này khó quá a ?i :(((--
--where current_year - to_number(to_char(student.birthday, 'YYYY')) > 20;
--select student.name, current_year - to_number(to_char(student.birthday, 'YYYY')) age
--from student, (select to_number(to_char(sysdate, 'YYYY')) current_year from dual)
--where current_year - to_number(to_char(student.birthday, 'YYYY')) > 20;
--3--
SELECT student.name
FROM student
WHERE TO_CHAR(student.birthday,'MM')IN('01', '02', '03') AND TO_CHAR(student.birthday, 'YYYY') = '1990';

/********* D. JOIN QUERY *********/
--1--
SELECT * 
FROM student
INNER JOIN faculty ON student.faculty_id = faculty.id
WHERE faculty.name ='Anh - V?n' OR faculty.name ='V?t lý';
--2--
SELECT student.name, faculty.name
FROM student
JOIN faculty 
ON student.faculty_id = faculty.id
AND student.gender = 'Nam';
--3--
SELECT student.name, exam_management.mark 
FROM exam_management
JOIN student 
ON student.id = exam_management.student_id
WHERE number_of_exam_taking = 1 AND subject_id = 1
AND mark= (SELECT max(mark) FROM exam_management
WHERE number_of_exam_taking = 1 AND subject_id = 1);
--4--
SELECT student.name, faculty.name, current_year - to_number(to_char(student.birthday, 'YYYY')) AS age
FROM faculty , student, (select to_number(to_char(sysdate, 'YYYY')) current_year from dual)
WHERE faculty.name = 'Anh - V?n' AND student.faculty_id = faculty.id
AND  current_year - to_number(to_char(student.birthday, 'YYYY')) =(SELECT MAX(current_year - to_number(to_char(student.birthday, 'YYYY')))from student);
--5--
SELECT faculty.name, COUNT(student.id) 
FROM  student 
INNER JOIN faculty
ON faculty.id = student.faculty_id 
GROUP BY faculty.name 
HAVING COUNT(student.faculty_id)>= ALL(SELECT COUNT(student.id) FROM student GROUP BY student.faculty_id);
--6--
SELECT faculty.name, COUNT(student.id) 
FROM  student 
INNER JOIN faculty
ON faculty.id = student.faculty_id
AND student.gender = 'N?'
GROUP BY faculty.name 
HAVING COUNT(student.faculty_id)>= ALL(SELECT COUNT(student.id) FROM student WHERE student.gender = 'N?' GROUP BY student.faculty_id);
--7--
SELECT student.name , MAX(mark) 
FROM student
INNER JOIN exam_management
ON  exam_management.student_id = student.id
GROUP BY student.name;
--8--
SELECT faculty.name, COUNT(student.id) 
FROM faculty
JOIN student 
ON faculty.id = student.faculty_id
GROUP BY faculty.name 
HAVING COUNT(student.id) = 0;
--9--
SELECT student.name, COUNT(subject_id) 
FROM exam_management
JOIN student 
ON exam_management.student_id = student.id
WHERE NOT exam_management.subject_id = 1
GROUP BY student.name;
--10--
SELECT * FROM exam_management;
SELECT student.name
FROM exam_management
JOIN student 
ON student.id = exam_management.student_id
WHERE number_of_exam_taking = 2 AND NOT EXISTS (SELECT id , student_id, subject_id, exam_management.number_of_exam_taking , mark
FROM exam_management WHERE number_of_exam_taking = 1 AND student.id = exam_management.student_id);