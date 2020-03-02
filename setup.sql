spool d:setup.txt
set echo on
set serveroutput on

--Alex George
 --016304013
  --alex@skgeorge.com
   --Sophie Lee
    --Fall 2018
     --IS480 Advanced Database



------------------------------------------------------------------------------------------------
--                                   Table Structure                                          --
------------------------------------------------------------------------------------------------

describe students;
describe schclasses; 
describe enrollments;
describe courses;
describe waitlist;
describe majors;

select * from students;
select * from schclasses;
select * from enrollments;
select * from courses;
select * from waitlist;
select * from majors;

------------------------------------------------------------------------------------------------
--                                   Setup Tables                                             --
------------------------------------------------------------------------------------------------

drop table Waitlist;
drop table enrollments;
drop table prereq;
drop table schclasses;
drop table courses;
drop table students;
drop table majors;

create table MAJORS
	(major varchar2(4) Primary key,
	mdesc varchar2(30));
insert into majors values ('ACC','Accounting');
insert into majors values ('FIN','Finance');
insert into majors values ('IS','Information Systems');
insert into majors values ('MKT','Marketing');
insert into majors values ('MGMT','Management');
insert into majors values ('HRM','Human Resources');

create table STUDENTS 
	(snum varchar2(3) primary key,
	sname varchar2(10),
	standing number(1),
	major varchar2(4) constraint fk_students_major references majors(major),
	gpa number(2,1),
	major_gpa number(2,1));

insert into students values ('101','Andy',4,'IS',2.8,3.2);
insert into students values ('102','Betty',2,null,3.2,null);
insert into students values ('103','Cindy',4,'IS',2.5,3.5);
insert into students values ('104','David',2,'FIN',3.3,3.0);
insert into students values ('105','Ellen',1,'HRM',1.5,null);
insert into students values ('106','Frank',3,'MKT',1.2,2.9);
insert into students values ('107','George',4,'FIN',2.9,null);
insert into students values ('108','Holly',3,'ACC',2.2,2.2);
insert into students values ('109','Iris',4,'MGMT',3.5,3.4);
insert into students values ('110','Jon',4,'IS',3.8,3.9);
insert into students values ('111','Kat',4,'IS',3.6,3.9);
insert into students values ('112','Liam',4,'IS',4.0,3.9);
insert into students values ('113','Mathew',4,'IS',3.8,4.0);
insert into students values ('114','Nick',4,'IS',3.8,4.0);
insert into students values ('115','Oscar',4,'IS',4.0,4.0);
insert into students values ('116','Perry',4,'IS',4.0,4.0);
insert into students values ('117','Quin',4,'IS',4.0,4.0);




create table COURSES
	(dept varchar2(3) constraint fk_courses_dept references majors(major),
	cnum varchar2(3),
	ctitle varchar2(30),
	crhr number(3),
	standing number(1),
	primary key (dept,cnum));

insert into courses values ('IS','300','Intro to MIS',3,2);
insert into courses values ('IS','301','Business Communicatons',4,2);
insert into courses values ('IS','310','Statistics',5,2);
insert into courses values ('IS','355','Networks',4,3);
insert into courses values ('IS','380','Database',4,3);
insert into courses values ('IS','385','Systems',10,3);
insert into courses values ('IS','480','Adv Database',3,4);

create table SCHCLASSES (
	callnum number(5) primary key,
	year number(4),
	semester varchar2(3),
	dept varchar2(3),
	cnum varchar2(3),
	section number(2),
	capacity number(3));

alter table schclasses 
	add constraint fk_schclasses_dept_cnum foreign key 
	(dept, cnum) references courses (dept,cnum);

insert into schclasses values (10110,2018,'Fa','IS','300',1,4);
insert into schclasses values (10115,2018,'Fa','IS','300',2,3);
insert into schclasses values (10160,2018,'Fa','IS','355',1,3);
insert into schclasses values (10120,2018,'Fa','IS','380',1,5);
insert into schclasses values (10125,2018,'Fa','IS','385',1,2);
insert into schclasses values (10130,2018,'Fa','IS','301',1,3);
insert into schclasses values (10180,2018,'Fa','IS','301',2,4);
insert into schclasses values (10170,2018,'Fa','IS','480',1,2);
insert into schclasses values (10140,2018,'Fa','IS','480',2,3);
insert into schclasses values (10150,2018,'Fa','IS','355',1,1);
insert into schclasses values (10190,2018,'Fa','IS','310',1,2);

create table PREREQ
	(dept varchar2(3),
	cnum varchar2(3),
	pdept varchar2(3),
	pcnum varchar2(3),
	primary key (dept, cnum, pdept, pcnum));
alter table Prereq 
	add constraint fk_prereq_dept_cnum foreign key 
	(dept, cnum) references courses (dept,cnum);
alter table Prereq 
	add constraint fk_prereq_pdept_pcnum foreign key 
	(pdept, pcnum) references courses (dept,cnum);

insert into prereq values ('IS','380','IS','300');
insert into prereq values ('IS','380','IS','301');
insert into prereq values ('IS','380','IS','310');
insert into prereq values ('IS','385','IS','310');
insert into prereq values ('IS','355','IS','300');
insert into prereq values ('IS','480','IS','380');

create table Waitlist (
	snum varchar2(3) constraint fk_waitlist_snum references students(snum),
	callnum number(5) constraint fk_waitlist_callnum references schclasses(callnum),
	requested date,
	primary key (snum, callnum));

create table ENROLLMENTS (
	snum varchar2(3) constraint fk_enrollments_snum references students(snum),
	callnum number(5) constraint fk_enrollments_callnum references schclasses(callnum),
	grade varchar2(2),
	primary key (snum, callnum));

insert into enrollments values (101,10110,'A');
insert into enrollments values (101,10125,null);
insert into enrollments values (102,10110,'B');
insert into enrollments values (101,10150,null);
insert into enrollments values (102,10125,null);
insert into enrollments values (102,10130,null);
insert into enrollments values (103,10120,'C');
insert into enrollments values (104,10170,null);
insert into enrollments values (109,10190,null);
insert into enrollments values (109,10170,null);
insert into enrollments values (109,10180,'B');
insert into enrollments values (110,10190,null);
insert into enrollments values (110,10170,null);
insert into enrollments values (111,10125,null);
insert into enrollments values (111,10190,null);
insert into enrollments values (112,10130,null);
insert into enrollments values (113,10110,null);
commit;



------------------------------------------------------------------------------------------------
--                                   Test Data                                                --
------------------------------------------------------------------------------------------------

--check valid student
declare
	v_errTxt varchar2(1000);
begin
	v_errTxt := Enroll.validate_Snum(120);
	dbms_output.put_line(v_errTxt);
end;
/

--check valid class number 
declare
	v_errTxt varchar2(1000);
begin
	Enroll.validate_Callnum(12345, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check repeat enrollment
declare
	v_errTxt varchar2(1000);
begin
	Enroll.repeat_enrolled(102, 10110, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check double enrollment
declare
	v_errTxt varchar2(1000);
begin
	Enroll.double_enrolled(102, 10115, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check 15-Hour-Rule
declare
	v_errTxt varchar2(1000);
begin
	Enroll.check_creditHours(102, 10130, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check student standing 
declare
	v_errTxt varchar2(1000);
begin
	Enroll.student_Standing(105, 10130, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check disqualified
declare
	v_errTxt varchar2(1000);
begin
	Enroll.disqualified (106, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check capacity
declare
	v_errTxt varchar2(1000);
begin
	Enroll.check_Capacity(102, 10170, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check waitlist dropped unsuccessful 
declare
	v_errTxt varchar2(1000);
begin
	Enroll.waitList(106, 10110, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--check repeat waitlist
declare
	v_errTxt varchar2(1000);
begin
	Enroll.repeat_waitList(106, 10125, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

declare
	v_errTxt varchar2(1000);
begin
	Enroll.repeat_waitList(106, 10125, v_errTxt);
	dbms_output.put_line(v_errTxt);
end;
/

--------------
--check AddMe
--------------

--check valid student number
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(100, 10130, p_error_message);
end;
/

--check valid class number
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(102, 10000, p_error_message);
end;
/

--check repeat enrollment
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(113, 10110, p_error_message);
end;
/

--check double enrollment and repeat enrollment 
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(103, 10120, p_error_message);
end;
/

--check 15-Hour-Rule
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(111, 10160, p_error_message);
end;
/

--check standing requirement 
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(105, 10140, p_error_message);
end;
/

--check disqualified Status 
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(106, 10110, p_error_message);
end;
/

--check capacity
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(113, 10130, p_error_message);
end;
/

--check repeat waitList

declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(107, 10125, p_error_message);
end;
/

--successfully enrolled
declare
	p_error_message varchar2(1000);
begin
	Enroll.AddMe(112, 10115, p_error_message);
end;
/

--------------
--check DropMe
--------------

--check valid student number
exec Enroll.DropMe(1, 10110);

--check valid class number
exec Enroll.DropMe(101, 1);


--check not enrolled
exec enroll.DropMe(112, 10125);

--check already graded
exec enroll.DropMe(103, 10120);

--check successfully dropped student 
exec enroll.DropMe(112, 10130);
exec enroll.DropMe(112, 10110);

select * from enrollments;

------------------------------------------------------------------------------------------------
--                                   Enroll Package                                           --
------------------------------------------------------------------------------------------------

----------------------------------------------
create or replace package Enroll as
----------------------------------------------

Function validate_Snum(
	p_snum IN students.snum%type)
	return varchar2;

procedure validate_Callnum(
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2);

procedure repeat_enrolled(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2);	
	
procedure double_enrolled(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2);

procedure check_creditHours(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2);

procedure student_Standing(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2);

procedure disqualified (
	p_snum IN students.snum%type,
	v_errTxt OUT varchar2);
	
procedure check_Capacity(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2);	

procedure waitList(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2);
	
procedure repeat_waitList(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2);	

procedure check_enrolled(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2);

procedure check_grade(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2);

procedure AddMe(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	p_error_message OUT varchar2);

procedure DropMe(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type);
	
----------------------------------------------
END Enroll;
/

------------------------------------------------------------------------------------------------
--                                   Enroll Package Body                                      --
------------------------------------------------------------------------------------------------

-----------------------------------------------
create or replace package body Enroll as
-----------------------------------------------

Function validate_Snum(
	p_snum IN students.snum%type)
	Return varchar2 as
		v_errTxt varchar2(200);
		v_count number;
begin

	select count(snum) into v_count
	from students
	where snum=p_snum;
	
if v_count = 0 then
	 v_errTxt := 'Error!, student number '||p_snum||' is not valid. ';
	 
else
	v_errTxt := null;
end if;
	return v_errTxt;
commit;
end;






procedure validate_Callnum(
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2) as
		v_count number;
begin
	select count(callnum) into v_count
	from Schclasses
	where callnum=p_callnum;
	
if v_count = 0 then
	v_errTxt := 'Error!, the class '||p_callnum||' is not invalid. ';

end if;
commit;
end;






procedure repeat_enrolled(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2) as
		v_count number;
begin

	select count(callnum) into v_count
	from Enrollments e
	where snum=p_snum 
	and p_callnum=e.callnum;
	
commit;
if v_count > 0 then
	v_errTxt := ' Error!, repeat enrollment. ';
end if;
end;






procedure double_enrolled(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2) is
	v_count number;
begin

	select count(e.callnum) into v_count
	from Enrollments e, schclasses sc, courses c
	where snum=p_snum 
	and sc.dept=c.dept 
	and sc.cnum=c.cnum
	and sc.callnum=p_callnum 
	and grade is not null;
commit;

if v_count != 0 then
	v_errTxt := ' Error!, double enrollment, you have already in this course in section number. ';
end if;
end;






procedure check_creditHours(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2) as
		v_CrHrAdded number;
		v_CrHrCheck number;
begin
	select CrHr into v_CrHrAdded
	from Schclasses sc, courses c
	where sc.callnum=p_callnum 
	and sc.dept=c.dept
	and sc.cnum=c.cnum;
	
	
select nvl(sum(CrHr),0) into v_CrHrCheck
	from Schclasses sc, courses c, enrollments e, students s
	where sc.dept=c.dept
	and sc.cnum=c.cnum and s.snum=p_snum
	and e.snum=s.snum and e.callnum=sc.callnum;
commit;

if v_CrHrAdded+v_CrHrCheck>=15 then
	v_errTxt := ' Error!, 15-Hour-Rule, the credit hours cannot exceed 15 units per semester. ';
end if;
end;






procedure student_Standing(
	p_snum IN students.snum%type,
	p_callnum IN schclasses.callnum%type,
	v_errTxt OUT varchar2) as
		v_studentStanding number;
		v_courseStanding number;
begin

	select standing into v_studentStanding
	from students
	where snum=p_snum;


	select c.standing into v_courseStanding
	from courses c, schclasses sc
	where callnum=p_callnum 
	and sc.dept=c.dept
	and sc.cnum=c.cnum;

if v_studentStanding <= v_courseStanding then
	v_errTxt := ' Error!, Student does not meet the standing requirements. ';
end if;
end;






procedure disqualified (
	p_snum IN students.snum%type,
	v_errTxt OUT varchar2) as
		v_studentStanding  students.standing%type;
		v_studentGPA students.gpa%type;
begin

	select standing into v_studentStanding 
	from students
	where snum=p_snum;

	select gpa into v_studentGPA
	from students
	where snum=p_snum;

if v_studentStanding  > 1 
and v_studentGPA <= 2 then

	v_errTxt :=  ' Error!, disqualified status, Student does not meet the GPA requirement of 2.0 or more. ';
else
	v_errTxt := null;
end if;
end;






procedure check_Capacity(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2) as
		v_count number;
		v_capacity number;
begin

	select nvl(capacity,0) into v_capacity
	from schclasses sc
	where p_callnum=sc.callnum;
commit;

	select count(snum) into v_count
	from Enrollments
	where callnum=p_callnum;
commit;

if v_count > v_capacity then
	v_errTxt := ' Error!, capacity for '||p_callnum||' is full. ';
end if;
commit;
end;






procedure waitList(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2) as
	
begin

	--delete from waitlist
	delete from waitlist 
	where snum=p_snum 
	and callnum=p_callnum;
	
if SQL%FOUND then
	v_errTxt:= 'Congrats!, you are dropped from the waitlist. ';
else
	v_errTxt:= 'Error!, Student was not removed from waitlist';
end if;
end;






procedure repeat_waitList(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2) as
		v_count number;
begin
	select count(snum) into v_count
	from Waitlist
	where callnum=p_callnum
	and snum=p_snum;

if v_count = 1 then
	v_errTxt:=' Error!, Student is already on the waitlist for this class. ';
else
	v_errTxt:= null;
	
	--Insert Student into Waitlist Table
	insert into Waitlist values(p_snum, p_callnum, sysdate);
		dbms_output.put_line('Student number '||p_snum||' is on the wait list for class number '||p_callnum);
	commit;
end if;

end;






procedure check_enrolled(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2) as
	v_count number;
begin
	select count(e.snum) into v_count
	from enrollments e
	where callnum=p_callnum
	and p_snum=e.snum;

if v_count = 0 then
	v_errTxt:= ' Error!, student is not enrolled in this class. Error!, Student cannnot drop it. ';
else
	v_errTxt:= null;
end if;

end;






procedure check_grade(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	v_errTxt OUT varchar2) as
	v_count number;
begin
	select count(e.snum) into v_count
	from enrollments e
	where callnum=p_callnum 
	and p_snum=e.snum and grade is not null;

if v_count = 1 then
	v_errTxt:= ' Error!, Student cannot drop, you have already have a letter grade for this class. ';
else
	v_errTxt:= null;
end if;
end;






---------
--ADDME--
---------
procedure AddMe(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type,
	p_error_message OUT varchar2) as
		v_errTxt varchar2(1000);
		p_errMsg varchar2(1000);
begin

	--check valid student number 
	v_errTxt := validate_Snum(p_snum);
	p_errMsg := v_errTxt;

	--check valid class number 
	validate_Callnum(p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

if p_errMsg is null then
	--checking repeat enrollment
	repeat_enrolled(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

	--checking double enrollment
	double_enrolled(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

	--check no more than 15 Credit Hours
	check_creditHours(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

	--check student standing
	student_Standing(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

	--checking disqualified
	disqualified (p_snum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

	if p_errMsg is null then

	--check capacity
	check_Capacity(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;
		
	if p_errMsg is not null then
	
	repeat_waitList(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;
	p_error_message:=p_errMsg;
	commit;
		else
			--insert Student into Enrollments
			insert into Enrollments values(p_snum, p_callnum, null);
				dbms_output.put_line('Student '||p_snum||' is enrolled in class number '||p_callnum);
			p_error_message:=p_errMsg;
			commit;
		end if;
	else
	p_error_message:=p_errMsg;
		dbms_output.put_line(p_errMsg);
	end if;
else
	p_error_message:=p_errMsg;
		dbms_output.put_line(p_errMsg);
end if;
end;






----------
--DROPME--
----------
procedure DropMe(
	p_snum IN students.snum%type,
	p_callnum IN enrollments.callnum%type) as
		v_errTxt varchar2(1000);
		p_errMsg varchar2(1000);

begin
	--check valid student number 
	v_errTxt := validate_Snum(p_snum);
	p_errMsg := v_errTxt;

	--check valid class number 
	validate_Callnum(p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

if p_errMsg is null then

	--check already enrolled 
	check_enrolled(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;

	--check already recieved a letter grade  
	check_grade(p_snum, p_callnum, v_errTxt);
	p_errMsg := p_errMsg||v_errTxt;
	
	if p_errMsg is null then
	
	
		--start dropping 
		update enrollments 
		set grade='W' 
		where snum=p_snum 
		and callnum=p_callnum;
		--end dropping student 
		
		--print successfully dropped from class 
		dbms_output.put_line(p_snum||' has been successfully dropped from '||p_callnum);
		commit;
		
		--Cursor start (Loop start)
		for eachRecord in (
			select snum, callnum 
			from waitlist
			where callnum=p_callnum
			order by requested)loop
		
			AddMe(eachRecord.snum, eachRecord.callnum, p_errMsg);
			
			if p_errMsg is null then
			
				waitList(eachRecord.snum, eachRecord.callnum, v_errTxt);
				exit;
			end if;
			
		--end Loop	
		end loop;
	
	else
		dbms_output.put_line(p_errMsg);
	end if;
else
	dbms_output.put_line(p_errMsg);
end if;
end;

----------------------------------------------
END Enroll;
/



show err
spool off