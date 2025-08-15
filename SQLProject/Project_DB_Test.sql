use ExaminationSystem;
go
-- 1.1 Test TextMatch (should return 1 because student answer contains best answer)
SELECT dbo.TextMatch('The Structured Query Language is powerful', 'Structured Query Language') AS match_yes;

-- 1.2 Test TextMatch (should return 0 because not a match)
SELECT dbo.TextMatch('Python is great', 'Structured Query Language') AS match_no;

-- 1.3 Test ExamTotalDegree (ExamID=1, should match sum of question degrees in Relations.Contain)
SELECT dbo.ExamTotalDegree(1) AS total_degree_exam1;

-- 1.4 Test StudentExamTotal (StudentID=1, ExamID=1, should match total mark in Relations.Answering)
SELECT dbo.StudentExamTotal(1, 1) AS student_total_exam1;

---------------------------------------------------------------------

DECLARE @newExamId INT;
EXEC CreateExam
    @examname = 'Final Exam',
    @examtype = 'EXAM',
    @instructorid = 1,
    @starttime = '10:00',
    @endtime = '12:00',
    @allowreattemps = 0,
    @courseid = 1,
    @trackid = 1,
    @branchid = 1,
    @intakeid = 1,
    @examid = @newExamId OUTPUT;

SELECT @newExamId AS CreatedExamId;

-- Assuming we have MCQ and T&F questions for instructor 1
EXEC AddQuestionsRandom
    @examid = 1,
    @instructorid = 1,
    @count_mcq = 1,
    @count_tf = 0,
    @count_text = 0,
    @default_degree = 2;

SELECT * FROM Relations.Contain WHERE ExamId = 1;

-- Add question ID=1 to ExamID=1 with degree 3
EXEC AddQuestionManual
    @examid = 1,
    @questionid = 1,
    @degree = 3;

EXEC CreateQuestionMCQ
    @questiontext = 'What does HTML stand for?',
    @correctanswer = 'HyperText Markup Language',
    @instructorid = 1,
    @choices = 'HyperText Markup Language|HighText Machine Language|Hyperlink and Text Markup Language';

SELECT * FROM Examination.Question;
SELECT * FROM Examination.Choise;

EXEC CreateQuestionTF
    @questiontext = 'The sky is blue.',
    @correctanswer = 'True',
    @instructorid = 1;

EXEC CreateQuestionText
    @questiontext = 'Explain normalization in databases.',
    @bestanswer = 'Process of organizing data to reduce redundancy',
    @instructorid = 1;

DECLARE @students IntList;
INSERT INTO @students (id) VALUES (1);

EXEC SelectStudents
    @examid = 1,
    @instructorid = 1,
    @examdate = '2025-08-16',
    @studentids = @students;

SELECT * FROM Relations.Selection;

-- Should pass if within exam time & date
EXEC RecordAnswer
    @studentid = 1,
    @questionid = 1,
    @answertext = 'Structured Query Language';


	EXEC FinalizeExam
    @studentid = 1,
    @examid = 1;

SELECT * FROM Relations.Examine WHERE StudentID = 1 AND ExamID = 1;

EXEC ManualMark
    @studentid = 1,
    @questionid = 1,
    @iscorrect = 1,
    @mark = 4;

SELECT * FROM Relations.Answering WHERE StudentID = 1 AND QuestionID = 1;

-- All MCQs for instructor 1 containing "SQL"
EXEC SearchQuestions @instructorid = 1, @type = 'MCQ', @text = 'SQL';

EXEC ListExams @year = YEAR(GETDATE());

EXEC StudentSchedule @studentid = 1;

EXEC DtudentResults @studentid = 1;

-- Insert with degree higher than course.MaxDegree
INSERT INTO Relations.Contain (ExamId, QuestionId, QuestionDegree)
VALUES (1, 1, 9999); -- Should ROLLBACK with error

-- First, create a course with another instructor
INSERT INTO Core.Course (Description, CourseName, MinDegree, MaxDegree, InstructorID)
VALUES ('Test Course', 'TestC', 10, 100, NULL);

-- Attempt to insert mismatch
INSERT INTO Relations.Have (TrackID, BranchID, InTakeID, CourseId, ExamId)
VALUES (1, 1, 1, 2, 1); -- Should fail if instructors differ

INSERT INTO Relations.Answering (StudentID, QuestionID, AnswerText)
VALUES (1, 1, 'Structured Query Language');

SELECT * FROM Relations.Answering WHERE StudentID = 1 AND QuestionID = 1;


