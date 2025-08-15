create database ExaminationSystem
ON PRIMARY
(
    NAME = ExaminationSystem,
    FILENAME = 'F:\DEPI\technical\MS_SQL_Server\SQL_Project\SQL\ExaminationSystem.mdf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = ExaminationSystem_Log,
    FILENAME = 'F:\DEPI\technical\MS_SQL_Server\SQL_Project\SQL\ExaminationSystem.ldf',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
);
use ExaminationSystem;
go
---------------------------------------------------------------------
create schema Users;
go
create schema Examination;
go
create schema Core;
go
Create schema Relations;
go
---------------------------------------------------------------------
create table Users.Manager(
	ManagerID int identity(1,1) primary key,
	FName nvarchar(255) not null check(len(FName)>0),
	LName nvarchar(255) not null check(len(LName)>0),
	Password nvarchar(255) not null check(len(Password)>6),
	Email nvarchar(255) not null check (Email LIKE '_%@_%._%'),
	Phone nvarchar(255) not null check ((Phone LIKE '01[0125][0-9]%') and (len(Phone) = 11))
);
go
create table Users.Instructor(
	InstructorId int identity(1,1) primary key,
	FName nvarchar(255) not null check(len(FName)>0),
	LName nvarchar(255) not null check(len(LName)>0),
	Password nvarchar(255) not null check(len(Password)>6),
	Email nvarchar(255) not null check (Email LIKE '_%@_%._%'),
	Phone nvarchar(255) not null check ((Phone LIKE '01[0125][0-9]%') and (len(Phone) = 11))
);
go
create table Users.Student(
	StudentID int identity(1,1) primary key,
	FName nvarchar(255) not null check(len(FName)>0),
	LName nvarchar(255) not null check(len(LName)>0),
	Password nvarchar(255) not null check(len(Password)>6),
	Email nvarchar(255) not null check (Email LIKE '_%@_%._%'),
	Phone nvarchar(255) not null check ((Phone LIKE '01[0125][0-9]%') and (len(Phone) = 11))
);
go
create table Examination.Exam(
	ExamID int identity(1,1) primary key,
	ExamName nvarchar(255) not null,
	ExamYear int not null default (year(getdate())),
	ExamType nvarchar(255) not null check (upper(ExamType) in ('EXAM','CORRECTIVE')),
	StartTime Time not null check (StartTime > '00:00:00'),
	EndTime Time not null check (EndTime > '00:00:00'),
	AllowReattemps int not null check(AllowReattemps >= 0),
	InstructorID int null,
	constraint FK_Exam_Instructor foreign key (InstructorID) references Users.Instructor (InstructorId)
	on update cascade on delete set null
);
go
create table Examination.Question(
	QuestionId int identity(1,1) primary key,
	QuestionText nvarchar(255) not null check(len(QuestionText)>0),
	BestAnswer nvarchar(255) null,
	QuestionType nvarchar(255) not null check (upper(QuestionType) in ('MCQ','T&F','TEXT')),
	CorrectAnswer nvarchar(255) null,
	InstructorID int null,
	CONSTRAINT CK_QuestionType check (((upper(QuestionType) = 'TEXT') and (BestAnswer is not null) and (CorrectAnswer is null)) or
									((upper(QuestionType) in ('MCQ','T&F')) and (CorrectAnswer is not null) and (BestAnswer is null))),		
	constraint FK_Question_Instructor foreign key (InstructorID) references Users.Instructor (InstructorId)
	on update cascade on delete set null
);
go
create table Examination.Choise(
	ChoiseID int identity(1,1),
	ChoiseText nvarchar(255) not null,
	IsCorrect bit not null default 0,
	QuestionId int not null,
	constraint PK_Choise primary key (ChoiseID,QuestionId),
	constraint FK_Choise_Question foreign key (QuestionId) references Examination.Question (QuestionId)
	on update cascade on delete cascade
);
go
create table Core.Course(
	CourseID int identity(1,1) primary key,
	Description nvarchar(255) not null,
	CourseName nvarchar(255) not null unique,
	MinDegree int not null check(MinDegree >= 0),
	MaxDegree int not null,
	CourseYear int not null default (year(getdate())),
	InstructorID int null,
	constraint CK_MaxDegree check(MaxDegree > MinDegree),
	constraint FK_Course_Instructor foreign key (InstructorID) references Users.Instructor (InstructorId)
	on update cascade on delete set null
);
go
create table Core.Track(
	TrackId int identity(1,1) primary Key,
	TrackName nvarchar(255) not null unique,
	Departement nvarchar(255) not null
);
go
create table Core.Branch(
	BranchId int identity(1,1) primary Key,
	BranchName nvarchar(255) not null unique,
);
go
create table Core.Intake(
	IntakeId int identity(1,1) primary Key,
	InTakeName nvarchar(255) not null unique,
	StartDate datetime not null default (getdate()),
	EndDate datetime not null default (dateadd(month,1,getdate())),
	constraint CK_EndDate check(EndDate > StartDate)
);
go
create table Relations.Manage(
	ManagerID int not null,
	TrackID int not null,
	BranchID int not null,
	InTakeID int not null,
	constraint PK_Manage primary key (ManagerID,TrackID,BranchID,InTakeID),
	constraint Fk_Manage_Manager foreign key (ManagerID) references Users.Manager (ManagerID)
	on update cascade on delete cascade,
	constraint Fk_Manage_Track foreign key (TrackID) references Core.Track (TrackId)
	on update cascade on delete cascade,
	constraint Fk_Manage_Branch foreign key (BranchID) references Core.Branch (BranchId)
	on update cascade on delete cascade,
	constraint Fk_Manage_InTake foreign key (InTakeID) references Core.Intake(IntakeId)
	on update cascade on delete cascade,
);
go
create table Relations.Addition(
	StudentID int not null,
	ManagerID int not null,
	TrackId int,
	BranchId int,
	InTakeId int,
	constraint PK_Addition primary key (StudentID,ManagerID),
	constraint Fk_Addition_Manager foreign key (ManagerID) references Users.Manager (ManagerID)
	on update cascade on delete cascade,
	constraint Fk_Addition_Student foreign key (StudentID) references Users.Student (StudentID)
	on update cascade on delete cascade,
	constraint Fk_Addition_Track foreign key (TrackId) references Core.Track (TrackId)
	on update cascade on delete set null,
	constraint Fk_Addition_Branch foreign key (BranchId) references Core.Branch (BranchId)
	on update cascade on delete set null,
	constraint Fk_Addition_InTake foreign key (InTakeId) references Core.Intake(IntakeId)
	on update cascade on delete set null
);
go
create table Relations.Answering(
	StudentID int not null,
	QuestionId int not null,
	AnswerText nvarchar(255) not null ,
	IsCorrect bit not null default 0,
	Mark int not null default 0,
	constraint PK_Answering primary key (StudentID,QuestionId),
	constraint Fk_Answering_Student foreign key (StudentID) references Users.Student (StudentID)
	on update cascade on delete cascade,
	constraint Fk_Answering_Question foreign key (QuestionId) references Examination.Question (QuestionId)
	on update cascade on delete cascade,
);
go
create table Relations.Register(
	StudentID int not null,
	CourseId int not null,
	constraint PK_Register primary key (StudentID,CourseId),
	constraint Fk_Register_Student foreign key (StudentID) references Users.Student (StudentID)
	on update cascade on delete cascade,
	constraint Fk_Register_Course foreign key (CourseId) references Core.Course (CourseID)
	on update cascade on delete cascade,
);
go
create table Relations.Examine(
	StudentID int not null,
	ExamId int not null,
	TotalDegree int not null,
	constraint PK_Examine primary key (StudentID,ExamId),
	constraint Fk_Examine_Student foreign key (StudentID) references Users.Student (StudentID)
	on update cascade on delete cascade,
	constraint Fk_Examine_Exam foreign key (ExamId) references Examination.Exam (ExamID)
	on update cascade on delete cascade,
);
go
create table Relations.Selection(
	StudentID int primary key,
	InstructorID int ,
	ExamId int,
	ExamDate datetime not null default(getdate()),
	constraint Fk_Selection_Student foreign key (StudentID) references Users.Student (StudentID)
	on update cascade on delete cascade,
	constraint Fk_Selection_Instructor foreign key (InstructorID) references Users.Instructor (InstructorId),
	constraint Fk_Selection_Exam foreign key (ExamId) references Examination.Exam (ExamID)
);
go
create table Relations.Contain(
	ExamId int not null,
	QuestionId int not null,
	QuestionDegree int not null default 1,
	constraint PK_Contain primary key (ExamId,QuestionId),
	constraint Fk_Contain_Exam foreign key (ExamId) references Examination.Exam (ExamID),
	constraint Fk_Contain_Question foreign key (QuestionId) references Examination.Question (QuestionId)
);
go
create table Relations.Have(
	TrackID int not null,
	BranchID int not null,
	InTakeID int not null,
	CourseId int not null,
	ExamId int not null,
	constraint PK_Have primary key (TrackID,BranchID,InTakeID,CourseId,ExamId),
	constraint Fk_Have_Track foreign key (TrackID) references Core.Track (TrackId)
	on update cascade on delete cascade,
	constraint Fk_Have_Branch foreign key (BranchID) references Core.Branch (BranchId)
	on update cascade on delete cascade,
	constraint Fk_Have_InTake foreign key (InTakeID) references Core.Intake(IntakeId)
	on update cascade on delete cascade,
	constraint Fk_Have_Course foreign key (CourseId) references Core.Course (CourseID)
	on update cascade on delete cascade,
	constraint Fk_Have_Exam foreign key (ExamId) references Examination.Exam (ExamID)
	on update no action on delete no action
);
go
---------------------------------------------------------------------
-- 1. Users
INSERT INTO Users.Manager (FName, LName, Password, Email, Phone)
VALUES ('Alice', 'Smith', 'StrongPass1', 'alice.smith@email.com', '01012345678');

INSERT INTO Users.Instructor (FName, LName, Password, Email, Phone)
VALUES ('John', 'Doe', 'StrongPass2', 'john.doe@email.com', '01123456789');

INSERT INTO Users.Student (FName, LName, Password, Email, Phone)
VALUES ('Emma', 'Brown', 'StrongPass3', 'emma.brown@email.com', '01234567890');

-- 2. Core
INSERT INTO Core.Track (TrackName, Departement)
VALUES ('Software Engineering', 'Computer Science');

INSERT INTO Core.Branch (TrackName)
VALUES ('Main Campus');

INSERT INTO Core.Intake (TrackName)
VALUES ('Spring 2025');

-- 3. Course
INSERT INTO Core.Course (Description, CourseName, MinDegree, MaxDegree, InstructorID)
VALUES ('Intro to Databases', 'Database Systems', 50, 100, 1);

-- 4. Exam
INSERT INTO Examination.Exam (ExamName, ExamType, StartTime, EndTime, AllowReattemps, InstructorID)
VALUES ('Midterm Exam', 'EXAM', '09:00', '11:00', 1, 1);

-- 5. Question
INSERT INTO Examination.Question (QuestionText, QuestionType, CorrectAnswer, InstructorID)
VALUES ('What is SQL?', 'MCQ', 'Structured Query Language', 1);

-- 6. Choice
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
VALUES ('Structured Query Language', 1, 1),
       ('Simple Question List', 0, 1),
       ('Sequential Query Logic', 0, 1);

-- 7. Relations
INSERT INTO Relations.Manage (ManagerID, TrackID, BranchID, InTakeID)
VALUES (1, 1, 1, 1);

INSERT INTO Relations.Addition (StudentID, ManagerID, TrackId, BranchId, InTakeId)
VALUES (1, 1, 1, 1, 1);

INSERT INTO Relations.Register (StudentID, CourseId)
VALUES (1, 1);

INSERT INTO Relations.Examine (StudentID, ExamId, TotalDegree)
VALUES (1, 1, 85);

INSERT INTO Relations.Selection (StudentID, InstructorID, ExamId)
VALUES (1, 1, 1);

INSERT INTO Relations.Contain (ExamId, QuestionId, QuestionDegree)
VALUES (1, 1, 5);

INSERT INTO Relations.Have (TrackID, BranchID, InTakeID, CourseId, ExamId)
VALUES (1, 1, 1, 1, 1);

INSERT INTO Relations.Answering (StudentID, QuestionId, AnswerText, IsCorrect, Mark)
VALUES (1, 1, 'Structured Query Language', 1, 5);

---------------------------------------------------------------------
USE ExaminationSystem;
GO

---------------------------------------------------------------------
-- 1) USERS: Managers, Instructors, Students (10 rows each)
---------------------------------------------------------------------
INSERT INTO Users.Manager (FName, LName, Password, Email, Phone) VALUES
('Alice',    'Johnson', 'Manager#01', 'alice.johnson@uni.edu', '01012345678'),
('Bob',      'Smith',   'Manager#02', 'bob.smith@uni.edu',     '01123456789'),
('Carol',    'White',   'Manager#03', 'carol.white@uni.edu',   '01234567890'),
('David',    'Brown',   'Manager#04', 'david.brown@uni.edu',   '01598765432'),
('Eve',      'Black',   'Manager#05', 'eve.black@uni.edu',     '01011112222'),
('Frank',    'Adams',   'Manager#06', 'frank.adams@uni.edu',   '01122223333'),
('Grace',    'Miller',  'Manager#07', 'grace.miller@uni.edu',  '01233334444'),
('Hank',     'Wilson',  'Manager#08', 'hank.wilson@uni.edu',   '01544445555'),
('Ivy',      'Green',   'Manager#09', 'ivy.green@uni.edu',     '01055556666'),
('Jack',     'King',    'Manager#10', 'jack.king@uni.edu',     '01166667777');
GO

INSERT INTO Users.Instructor (FName, LName, Password, Email, Phone) VALUES
('Alan',     'Turing',      'Instructor1', 'alan.turing@uni.edu',      '01010101010'),
('Barbara',  'Liskov',      'Instructor2', 'barbara.liskov@uni.edu',   '01120202020'),
('Charles',  'Babbage',     'Instructor3', 'charles.babbage@uni.edu',  '01230303030'),
('Dorothy',  'Vaughan',     'Instructor4', 'dorothy.vaughan@uni.edu',  '01540404040'),
('Edsger',   'Dijkstra',    'Instructor5', 'edsger.dijkstra@uni.edu',  '01050505050'),
('Frances',  'Allen',       'Instructor6', 'frances.allen@uni.edu',    '01160606060'),
('Guido',    'vanRossum',   'Instructor7', 'guido.vanrossum@uni.edu',  '01270707070'),
('Hedy',     'Lamarr',      'Instructor8', 'hedy.lamarr@uni.edu',      '01580808080'),
('Ian',      'Goodfellow',   'Instructor9', 'ian.goodfellow@uni.edu',   '01090909090'),
('Jane',     'Street',      'Instructor10','jane.street@uni.edu',     '01101010101');
GO

INSERT INTO Users.Student (FName, LName, Password, Email, Phone) VALUES
('Student', 'One',   'Student#01', 'student1@uni.edu', '01099990001'),
('Student', 'Two',   'Student#02', 'student2@uni.edu', '01199990002'),
('Student', 'Three', 'Student#03', 'student3@uni.edu', '01299990003'),
('Student', 'Four',  'Student#04', 'student4@uni.edu', '01599990004'),
('Student', 'Five',  'Student#05', 'student5@uni.edu', '01088880005'),
('Student', 'Six',   'Student#06', 'student6@uni.edu', '01188880006'),
('Student', 'Seven', 'Student#07', 'student7@uni.edu', '01288880007'),
('Student', 'Eight', 'Student#08', 'student8@uni.edu', '01588880008'),
('Student', 'Nine',  'Student#09', 'student9@uni.edu', '01077770009'),
('Student', 'Ten',   'Student#10', 'student10@uni.edu','01177770010');
GO

---------------------------------------------------------------------
-- 2) CORE: Tracks, Branches, Intakes (10 rows each)
---------------------------------------------------------------------
INSERT INTO Core.Track (TrackName, Departement) VALUES
('Software Engineering', 'Computer Science'),
('Data Science',        'Computer Science'),
('Cyber Security',      'Information Security'),
('AI & Machine Learning','Computer Science'),
('Web Development',     'Computer Science'),
('Cloud Computing',     'Information Technology'),
('Networking',          'Engineering'),
('Database Systems',    'Computer Science'),
('Embedded Systems',    'Electrical Engineering'),
('DevOps',              'Computer Science');
GO

INSERT INTO Core.Branch (BranchName) VALUES
('Main Campus - Cairo'),
('Main Campus - Giza'),
('New Cairo Branch'),
('Alexandria Branch'),
('Luxor Branch'),
('Aswan Branch'),
('Tanta Branch'),
('Mansoura Branch'),
('Suez Branch'),
('Ismailia Branch');
GO

INSERT INTO Core.Intake (InTakeName, StartDate, EndDate) VALUES
('Winter 2025','2025-01-01','2025-03-31'),
('Spring 2025','2025-04-01','2025-06-30'),
('Summer 2025','2025-07-01','2025-09-30'),
('Fall 2025',  '2025-10-01','2025-12-31'),
('Winter 2026','2026-01-01','2026-03-31'),
('Spring 2026','2026-04-01','2026-06-30'),
('Summer 2026','2026-07-01','2026-09-30'),
('Fall 2026',  '2026-10-01','2026-12-31'),
('Winter 2027','2027-01-01','2027-03-31'),
('Spring 2027','2027-04-01','2027-06-30');
GO

---------------------------------------------------------------------
-- 3) COURSES (10 rows) -> InstructorID must reference existing instructors
---------------------------------------------------------------------
INSERT INTO Core.Course (Description, CourseName, MinDegree, MaxDegree, InstructorID) VALUES
('Intro to Software Engineering', 'C_SE101', 50, 100, 1),
('Advanced Python Programming',  'C_PY201', 50, 100, 2),
('Data Analysis with Pandas',    'C_DS301', 50, 100, 3),
('Cybersecurity Fundamentals',   'C_CY101', 50, 100, 4),
('Machine Learning Basics',      'C_ML101', 50, 100, 5),
('Frontend Web Development',     'C_WD101', 50, 100, 6),
('AWS Cloud Essentials',         'C_CC101', 50, 100, 7),
('Networking Essentials',        'C_NW101', 50, 100, 8),
('Database Design',              'C_DB101', 50, 100, 9),
('DevOps Practices',             'C_DV101', 50, 100, 10);
GO

---------------------------------------------------------------------
-- 4) EXAMS (10 rows) -> ExamType must be 'EXAM' or 'CORRECTIVE'
---------------------------------------------------------------------
INSERT INTO Examination.Exam (ExamName, ExamType, StartTime, EndTime, AllowReattemps, InstructorID) VALUES
('SE101 Midterm',   'EXAM',       '09:00:00', '11:00:00', 0, 1),
('PY201 Final',     'EXAM',       '10:00:00', '12:00:00', 0, 2),
('DS301 Midterm',   'EXAM',       '08:30:00', '10:30:00', 1, 3),
('CY101 Midterm',   'EXAM',       '09:00:00', '11:00:00', 0, 4),
('ML101 Final',     'EXAM',       '13:00:00', '15:00:00', 0, 5),
('WD101 Quiz',      'CORRECTIVE', '14:00:00', '15:00:00', 1, 6),
('CC101 Final',     'EXAM',       '10:00:00', '12:00:00', 0, 7),
('NW101 Midterm',   'EXAM',       '11:00:00', '13:00:00', 0, 8),
('DB101 Final',     'EXAM',       '09:00:00', '11:00:00', 0, 9),
('DV101 Quiz',      'CORRECTIVE', '15:00:00', '16:00:00', 1, 10);
GO

---------------------------------------------------------------------
-- 5) RELATIONS.Have (link each exam to exactly one course + track/branch/intake)
--     We map exam i -> course i and track i, branch i, intake i
---------------------------------------------------------------------
INSERT INTO Relations.Have (TrackID, BranchID, InTakeID, CourseId, ExamId) VALUES
(1,1,1,1,1),
(2,2,2,2,2),
(3,3,3,3,3),
(4,4,4,4,4),
(5,5,5,5,5),
(6,6,6,6,6),
(7,7,7,7,7),
(8,8,8,8,8),
(9,9,9,9,9),
(10,10,10,10,10);
GO

---------------------------------------------------------------------
-- 6) QUESTIONS (10 rows) -- obey CK_QuestionType:
--    MCQ/T&F -> CorrectAnswer NOT NULL, BestAnswer NULL
--    TEXT  -> BestAnswer NOT NULL, CorrectAnswer NULL
---------------------------------------------------------------------
INSERT INTO Examination.Question (QuestionText, BestAnswer, QuestionType, CorrectAnswer, InstructorID) VALUES
-- MCQ
('What is SQL?',                   NULL, 'MCQ', 'Structured Query Language', 1),
('What is a Firewall?',            NULL, 'MCQ', 'Network Security Device',    4),
('What is HTML?',                  NULL, 'MCQ', 'HyperText Markup Language',  6),
('What is AWS S3?',                NULL, 'MCQ', 'Cloud Storage Service',      7),
('CI/CD stands for?',              NULL, 'MCQ', 'Continuous Integration and Continuous Deployment', 10),
-- T&F (use 'True' / 'False' as CorrectAnswer)
('Python is statically typed. True or False?', NULL, 'T&F', 'False', 2),
('TCP is connectionless. True or False?',      NULL, 'T&F', 'False', 8),
('Indexes speed up SELECT queries. True or False?', NULL, 'T&F', 'True', 9),
-- TEXT (BestAnswer not null)
('Explain normalization in databases.', 'Organizing data to reduce redundancy and improve integrity', 'TEXT', NULL, 3),
('Define overfitting in ML.', 'Model that performs well on training data but poorly on unseen data', 'TEXT', NULL, 5);
GO

---------------------------------------------------------------------
-- 7) CHOICES for MCQ questions
--    Use subselects to get QuestionId by QuestionText (safe even if IDs differ)
---------------------------------------------------------------------
-- Choices for 'What is SQL?'
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Structured Query Language', 1, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is SQL?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Simple Query List', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is SQL?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Sequential Query Logic', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is SQL?';

-- Choices for 'What is a Firewall?'
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Network Security Device', 1, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is a Firewall?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'A kind of router', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is a Firewall?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'A database engine', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is a Firewall?';

-- Choices for 'What is HTML?'
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'HyperText Markup Language', 1, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is HTML?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'HighText Machine Language', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is HTML?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Hyperlink and Text Markup', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is HTML?';

-- Choices for 'What is AWS S3?'
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Cloud Storage Service', 1, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is AWS S3?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Database Service', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is AWS S3?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Load Balancer', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'What is AWS S3?';

-- Choices for 'CI/CD stands for?'
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Continuous Integration and Continuous Deployment', 1, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'CI/CD stands for?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Centralized Input and Control', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'CI/CD stands for?';
INSERT INTO Examination.Choise (ChoiseText, IsCorrect, QuestionId)
SELECT 'Continuous Inspection and Continuous Debugging', 0, q.QuestionId FROM Examination.Question q WHERE q.QuestionText = 'CI/CD stands for?';
GO

---------------------------------------------------------------------
-- 8) RELATIONS: Manage, Addition, Register, Selection, Contain, Examine, Answering
---------------------------------------------------------------------
-- 8.1 Relations.Manage (ManagerID, TrackID, BranchID, InTakeID)
INSERT INTO Relations.Manage (ManagerID, TrackID, BranchID, InTakeID) VALUES
(1,1,1,1),(2,2,2,2),(3,3,3,3),(4,4,4,4),(5,5,5,5),
(6,6,6,6),(7,7,7,7),(8,8,8,8),(9,9,9,9),(10,10,10,10);
GO

-- 8.2 Relations.Addition (StudentID, ManagerID, TrackId, BranchId, InTakeId)
INSERT INTO Relations.Addition (StudentID, ManagerID, TrackId, BranchId, InTakeId) VALUES
(1,1,1,1,1),(2,2,2,2,2),(3,3,3,3,3),(4,4,4,4,4),(5,5,5,5,5),
(6,6,6,6,6),(7,7,7,7,7),(8,8,8,8,8),(9,9,9,9,9),(10,10,10,10,10);
GO

-- 8.3 Relations.Register (StudentID, CourseId)
INSERT INTO Relations.Register (StudentID, CourseId) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);
GO

-- 8.4 Relations.Selection (StudentID primary key, InstructorID, ExamId, ExamDate)
-- Note: StudentID is PK here so each student scheduled only once (per your schema)
INSERT INTO Relations.Selection (StudentID, InstructorID, ExamId, ExamDate) VALUES
(1,1,1, '2025-05-01 09:00:00'),
(2,2,2, '2025-05-02 10:00:00'),
(3,3,3, '2025-05-03 08:30:00'),
(4,4,4, '2025-05-04 09:00:00'),
(5,5,5, '2025-05-05 13:00:00'),
(6,6,6, '2025-05-06 14:00:00'),
(7,7,7, '2025-05-07 10:00:00'),
(8,8,8, '2025-05-08 11:00:00'),
(9,9,9, '2025-05-09 09:00:00'),
(10,10,10,'2025-05-10 15:00:00');
GO

-- 8.5 Relations.Contain (ExamId, QuestionId, QuestionDegree)
-- Ensure Relations.Have exists (we inserted it earlier) to satisfy ContainValidateTotal trigger
-- Use small degrees so sum <= course.MaxDegree
INSERT INTO Relations.Contain (ExamId, QuestionId, QuestionDegree) VALUES
(1,1,5),(2,2,5),(3,9,8),(4,4,5),(5,10,10),
(6,6,4),(7,7,6),(8,8,5),(9,3,7),(10,5,9);
GO

-- 8.6 Relations.Answering (StudentID, QuestionId, AnswerText)
-- Insert initial answers (AnsweringAutograde trigger will set IsCorrect/Mark for MCQ/T&F based on CorrectAnswer)
INSERT INTO Relations.Answering (StudentID, QuestionId, AnswerText) VALUES
(1,1,'Structured Query Language'),
(2,2,'False'),
(3,9,'Organizing data to reduce redundancy and improve integrity'),
(4,4,'Network Security Device'),
(5,10,'Continuous Integration and Continuous Deployment'),
(6,6,'HyperText Markup Language'),
(7,7,'Cloud Storage Service'),
(8,8,'Internet Protocol'),
(9,3,'Data Analysis Library'),
(10,5,'Model fits training data too well');
GO

-- 8.7 Relations.Examine (StudentID, ExamId, TotalDegree)
-- Provide TotalDegree initial values (can be updated later with FinalizeExam or proc)
INSERT INTO Relations.Examine (StudentID, ExamId, TotalDegree) VALUES
(1,1,5),(2,2,5),(3,3,8),(4,4,5),(5,5,10),
(6,6,4),(7,7,6),(8,8,5),(9,9,7),(10,10,9);
GO

---------------------------------------------------------------------
-- 9) Quick spot-check selects (optional)
-- (uncomment to run checks)
---------------------------------------------------------------------
-- SELECT COUNT(*) AS ManagersCount FROM Users.Manager;
-- SELECT COUNT(*) AS InstructorsCount FROM Users.Instructor;
-- SELECT COUNT(*) AS StudentsCount FROM Users.Student;
-- SELECT COUNT(*) AS CoursesCount FROM Core.Course;
-- SELECT COUNT(*) AS ExamsCount FROM Examination.Exam;
-- SELECT COUNT(*) AS QuestionsCount FROM Examination.Question;
-- SELECT COUNT(*) AS ChoicesCount FROM Examination.Choise;
-- SELECT COUNT(*) AS ContainCount FROM Relations.Contain;
-- SELECT COUNT(*) AS HaveCount FROM Relations.Have;
GO
