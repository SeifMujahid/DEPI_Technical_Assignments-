use ExaminationSystem;
go
---------------------------------------------------------------------
create nonclustered index ix_manager_email on users.manager (email);
go
create nonclustered index ix_instructor_email on users.instructor (email);
go
create nonclustered index ix_student_email on users.student (email);
go
create nonclustered index ix_exam_instructorid on examination.exam (instructorid);
go
create nonclustered index ix_exam_examtype_year on examination.exam (examtype, examyear);
go
create nonclustered index ix_question_instructorid on examination.question (instructorid);
go
create nonclustered index ix_question_type on examination.question (questiontype);
go
create nonclustered index ix_choise_questionid on examination.choise (questionid);
go
create nonclustered index ix_course_instructorid on core.course (instructorid);
go
create nonclustered index ix_course_name on core.course (coursename);
go
create nonclustered index ix_track_name on core.track (trackname);
go
create nonclustered index ix_branch_name on core.branch (branchname);
go
create nonclustered index ix_intake_name on core.intake (intakename);
go
create nonclustered index ix_intake_startdate on core.intake (startdate);
go
create nonclustered index ix_intake_enddate on core.intake (enddate);
go
create nonclustered index ix_contain_exam on relations.contain (examid);
go
create nonclustered index ix_contain_question on relations.contain (questionid);
go
---------------------------------------------------------------------
---------------------------------------------------------------------
-- functions
---------------------------------------------------------------------
create function TextMatch (
    @student nvarchar(4000),
    @best nvarchar(4000)
)
returns bit
as
begin
    declare @result bit = 0; 
    if @student is not null and @best is not null
    begin
        if lower(@student) like '%' + lower(@best) + '%'
            set @result = 1;
    end
    return @result;
end;
go

create function ExamTotalDegree (@examid int)
returns int
as
begin
    return isnull((select sum(c.questiondegree) from relations.contain c where c.examid = @examid), 0);
end;
go

create function StudentExamTotal (@studentid int, @examid int)
returns int
as
begin
    return isnull((
        select sum(isnull(a.mark,0))
        from relations.answering a
        join relations.contain c on c.questionid = a.questionid
        where c.examid = @examid and a.studentid = @studentid
    ),0);
end;
go

--------------------------------------------------------------------------------
-- triggers
--------------------------------------------------------------------------------
create trigger ContainValidateTotal
on relations.contain
after insert, update, delete
as
begin
    -- collect exam IDs from inserted/deleted rows
    select distinct examid
    into #e
    from (
        select examid from inserted
        union
        select examid from deleted
    ) x;

    -- map: count distinct course IDs per exam
    select examid, count(distinct courseid) as cnt
    into #map
    from relations.have h
    where exists (select 1 from #e t where t.examid = h.examid)
    group by examid;

    -- check: each exam linked to exactly one course
    if exists (select 1 from #map where cnt <> 1)
    begin
        raiserror('each exam must be linked to exactly one course in relations.have before validating total degree.', 16, 1);
        rollback tran;
        return;
    end;

    -- check: sum of question degrees <= course.maxdegree
    if exists (
        select 1
        from #e t
        join relations.have h on h.examid = t.examid
        join core.course c on c.courseid = h.courseid
        cross apply (select dbo.ExamTotalDegree(t.examid) as totaldeg) z
        where z.totaldeg > c.maxdegree
    )
    begin
        raiserror('sum of question degrees exceeds course.maxdegree.', 16, 1);
        rollback tran;
        return;
    end;
end;
go

create trigger HaveEnforceInstructor
on relations.have
after insert, update
as
begin
    if exists (
        select 1
        from inserted i
        join examination.exam e on e.examid = i.examid
        join core.course c on c.courseid = i.courseid
        where e.instructorid is not null and c.instructorid is not null
          and e.instructorid <> c.instructorid
    )
    begin
        raiserror('exam.instructorid must equal course.instructorid for the relation.', 16, 1);
        rollback tran; return;
    end
end;
go

create trigger AnsweringAutograde
on relations.answering
after insert, update
as
begin

    ;with a as (
        select studentid, questionid, answertext from inserted
    ),
    q as (
        select q.questionid, q.questiontype, q.correctanswer, q.bestanswer
        from examination.question q
        join a on a.questionid = q.questionid
    ),
    d as (
        select c.questionid, c.questiondegree
        from relations.contain c
        join a on a.questionid = c.questionid
    )
    update ans
      set iscorrect =
          case
            when upper(q.questiontype) in ('MCQ','T&F')
                 and ans.answertext = q.correctanswer then 1
            else 0
          end,
          mark =
          case
            when upper(q.questiontype) in ('MCQ','T&F')
                 and ans.answertext = q.correctanswer
                 then isnull(d.questiondegree,0)
            else 0
          end
    from relations.answering ans
    join a on a.studentid = ans.studentid and a.questionid = ans.questionid
    join q on q.questionid = ans.questionid
    left join d on d.questionid = ans.questionid;
end;
go

--------------------------------------------------------------------------------
-- procedures: questions & exams
--------------------------------------------------------------------------------
create procedure CreateExam
    @examname nvarchar(255),
    @examtype nvarchar(20),
    @instructorid int,
    @starttime time,
    @endtime time,
    @allowreattemps int = 0,
    @courseid int,
    @trackid int,
    @branchid int,
    @intakeid int,
    @examid int output
as
begin
    begin transaction;

    insert into examination.exam (examname, examtype, starttime, endtime, allowreattemps, instructorid)
    values (@examname, @examtype, @starttime, @endtime, @allowreattemps, @instructorid);

    set @examid = scope_identity();

    insert into relations.have (trackid, branchid, intakeid, courseid, examid)
    values (@trackid, @branchid, @intakeid, @courseid, @examid);

    commit;
end;
go

create procedure AddQuestionsRandom
    @examid int,
    @instructorid int = null,
    @count_mcq int = 0,
    @count_tf int = 0,
    @count_text int = 0,
    @default_degree int = 1
as
begin

    if @count_mcq > 0
    insert into relations.contain (examid, questionid, questiondegree)
    select top (@count_mcq) @examid, q.questionid, @default_degree
    from examination.question q
    where upper(q.questiontype) = 'MCQ'
      and (@instructorid is null or q.instructorid = @instructorid)
      and not exists (select 1 from relations.contain c where c.examid = @examid and c.questionid = q.questionid)
    order by newid();

    if @count_tf > 0
    insert into relations.contain (examid, questionid, questiondegree)
    select top (@count_tf) @examid, q.questionid, @default_degree
    from examination.question q
    where upper(q.questiontype) = 'T&F'
      and (@instructorid is null or q.instructorid = @instructorid)
      and not exists (select 1 from relations.contain c where c.examid = @examid and c.questionid = q.questionid)
    order by newid();

    if @count_text > 0
    insert into relations.contain (examid, questionid, questiondegree)
    select top (@count_text) @examid, q.questionid, @default_degree
    from examination.question q
    where upper(q.questiontype) = 'TEXT'
      and (@instructorid is null or q.instructorid = @instructorid)
      and not exists (select 1 from relations.contain c where c.examid = @examid and c.questionid = q.questionid)
    order by newid();
end;
go

create procedure AddQuestionManual
    @examid int,
    @questionid int,
    @degree int
as
begin
    set nocount on;
    insert into relations.contain (examid, questionid, questiondegree)
    values (@examid, @questionid, @degree);
end;
go

create procedure CreateQuestionMCQ
    @questiontext nvarchar(255),
    @correctanswer nvarchar(255),
    @instructorid int,
    @choices nvarchar(max) 
as
begin

    declare @qid int;
    insert into examination.question (questiontext, questiontype, bestanswer, correctanswer, instructorid)
    values (@questiontext, 'MCQ', null, @correctanswer, @instructorid);
    set @qid = scope_identity();

    declare @pos int = 1, @len int = len(@choices)+1, @next int, @piece nvarchar(255);
    while @pos <= @len
    begin
        set @next = charindex('|', @choices, @pos);
        if @next = 0 set @next = @len;
        set @piece = ltrim(rtrim(substring(@choices, @pos, @next - @pos)));
        if isnull(@piece,'') <> ''
            insert into examination.choise (choisetext, iscorrect, questionid)
            values (@piece, case when @piece = @correctanswer then 1 else 0 end, @qid);
        set @pos = @next + 1;
    end
end;
go

create procedure CreateQuestionTF
    @questiontext nvarchar(255),
    @correctanswer nvarchar(10),
    @instructorid int
as
begin
    set nocount on;
    insert into examination.question (questiontext, questiontype, bestanswer, correctanswer, instructorid)
    values (@questiontext, 'T&F', null, @correctanswer, @instructorid);
end;
go

create procedure CreateQuestionText
    @questiontext nvarchar(255),
    @bestanswer nvarchar(255),
    @instructorid int
as
begin
    set nocount on;
    insert into examination.question (questiontext, questiontype, bestanswer, correctanswer, instructorid)
    values (@questiontext, 'TEXT', @bestanswer, null, @instructorid);
end;
go

--------------------------------------------------------------------------------
-- procedures: selection, answering, results
--------------------------------------------------------------------------------
create type IntList as table (
    id int not null
);
go

create procedure SelectStudents
    @examid int,
    @instructorid int,
    @examdate datetime,
    @studentids IntList readonly
as
begin
    insert into relations.selection (studentid, instructorid, examid, examdate)
    select id, @instructorid, @examid, @examdate from @studentids;
end;
go

create procedure RecordAnswer
    @studentid int,
    @questionid int,
    @answertext nvarchar(255)
as
begin

    declare @examid int =
        (select top 1 c.examid from relations.contain c where c.questionid = @questionid);

    if @examid is null
    begin
        raiserror('question is not part of any exam.', 16, 1); return;
    end

    declare @examdate datetime, @start time, @end time;
    select top 1 @examdate = s.examdate
    from relations.selection s where s.studentid = @studentid and s.examid = @examid;

    if @examdate is null
    begin
        raiserror('student is not scheduled for this exam.', 16, 1); return;
    end

    select @start = e.starttime, @end = e.endtime
    from examination.exam e where e.examid = @examid;

    if not (
        convert(datetime, convert(date, getdate())) = convert(date, @examdate)
        and convert(time, getdate()) between @start and @end
    )
    begin
        raiserror('exam is not open for this student at this time.', 16, 1); return;
    end

    merge relations.answering as tgt
    using (select @studentid as studentid, @questionid as questionid) src
    on (tgt.studentid = src.studentid and tgt.questionid = src.questionid)
    when matched then update set answertext = @answertext
    when not matched then insert (studentid, questionid, answertext) values (@studentid, @questionid, @answertext);
end;
go

create procedure FinalizeExam
    @studentid int,
    @examid int
as
begin

    declare @total int;
    set @total = dbo.StudentExamTotal(@studentid, @examid);

    merge relations.examine as tgt
    using (select @studentid as studentid, @examid as examid) src
    on (tgt.studentid = src.studentid and tgt.examid = src.examid)
    when matched then
        update set totaldegree = @total
    when not matched then
        insert (studentid, examid, totaldegree)
        values (@studentid, @examid, @total);
end;
go


create procedure ManualMark
    @studentid int,
    @questionid int,
    @iscorrect bit,
    @mark int
as
begin
    update relations.answering
    set iscorrect = @iscorrect, mark = @mark
    where studentid = @studentid and questionid = @questionid;
end;
go

--------------------------------------------------------------------------------
-- procedures: searches / listings
--------------------------------------------------------------------------------
create procedure SearchQuestions
    @instructorid int = null,
    @type nvarchar(10) = null,
    @text nvarchar(255) = null
as
begin
    set nocount on;
    select
        q.questionid, q.questiontext, q.questiontype, q.instructorid,
        case when upper(q.questiontype) in ('MCQ','T&F') then q.correctanswer else q.bestanswer end as refanswer
    from examination.question q
    where (@instructorid is null or q.instructorid = @instructorid)
      and (@type is null or upper(q.questiontype) = upper(@type))
      and (@text is null or q.questiontext like '%' + @text + '%')
    order by q.questionid desc;
end;
go

create procedure ListExams
    @year int = null,
    @examtype nvarchar(20) = null,
    @courseid int = null,
    @trackid int = null,
    @branchid int = null,
    @intakeid int = null
as
begin
    select
        e.examid, e.examname, e.examyear, e.examtype, e.starttime, e.endtime,
        h.trackid, h.branchid, h.intakeid, h.courseid,
        c.coursename
    from examination.exam e
    join relations.have h on h.examid = e.examid
    join core.course c on c.courseid = h.courseid
    where (@year is null or e.examyear = @year)
      and (@examtype is null or e.examtype = @examtype)
      and (@courseid is null or h.courseid = @courseid)
      and (@trackid is null or h.trackid = @trackid)
      and (@branchid is null or h.branchid = @branchid)
      and (@intakeid is null or h.intakeid = @intakeid)
    order by e.examyear desc, e.examid desc;
end;
go

create procedure StudentSchedule
    @studentid int
as
begin
    select
        s.studentid, s.examid, s.examdate,
        e.examname, e.examtype, e.starttime, e.endtime,
        h.trackid, h.branchid, h.intakeid, h.courseid, c.coursename
    from relations.selection s
    join examination.exam e on e.examid = s.examid
    join relations.have h on h.examid = e.examid
    join core.course c on c.courseid = h.courseid
    where s.studentid = @studentid
    order by s.examdate, e.starttime;
end;
go

create procedure DtudentResults
    @studentid int
as
begin
    select
        ex.studentid, ex.examid, e.examname, e.examyear, e.examtype,
        ex.totaldegree, cc.maxdegree
    from relations.examine ex
    join examination.exam e on e.examid = ex.examid
    join relations.have h on h.examid = ex.examid
    join core.course cc on cc.courseid = h.courseid
    where ex.studentid = @studentid
    order by e.examyear desc, ex.examid desc;
end;
go

--------------------------------------------------------------------------------
-- views (simple read helpers)
--------------------------------------------------------------------------------
create view ExamSummary
as
select
    e.examid, e.examname, e.examtype, e.examyear, e.starttime, e.endtime,
    h.trackid, h.branchid, h.intakeid, h.courseid,
    c.coursename,
    dbo.ExamTotalDegree(e.examid) as total_question_degree
from examination.exam e
join relations.have h on h.examid = e.examid
join core.course c on c.courseid = h.courseid;
go

create view StudentAnswerDSetail
as
select
    a.studentid, a.questionid, q.questiontext, q.questiontype,
    a.answertext, a.iscorrect, a.mark
from relations.answering a
join examination.question q on q.questionid = a.questionid;
go

--------------------------------------------------------------------------------
-- roles, users, and permissions (sample)
-- run only if you want to enforce proc-only access
--------------------------------------------------------------------------------
-- roles
if not exists (select 1 from sys.database_principals where name = 'role_admin')
    create role role_admin;
if not exists (select 1 from sys.database_principals where name = 'role_manager')
    create role role_manager;
if not exists (select 1 from sys.database_principals where name = 'role_instructor')
    create role role_instructor;
if not exists (select 1 from sys.database_principals where name = 'role_student')
    create role role_student;
go

-- ================================
-- AUTO-DETECT SCHEMA AND GRANT
-- ================================

declare @ObjectsToGrant table
(
    ObjName sysname,
    ObjType char(1),  -- V = View, P = Procedure
    GrantType varchar(10), -- SELECT or EXECUTE
    Roles nvarchar(400)
);

-- Add Views
insert into @ObjectsToGrant values
('v_exam_summary', 'V', 'SELECT', 'role_manager, role_instructor, role_student'),
('v_student_answer_detail', 'V', 'SELECT', 'role_instructor, role_student');

-- Add Stored Procedures
insert into @ObjectsToGrant values
('sp_create_exam', 'P', 'EXECUTE', 'role_instructor'),
('sp_add_questions_random', 'P', 'EXECUTE', 'role_instructor'),
('sp_add_question_manual', 'P', 'EXECUTE', 'role_instructor'),
('sp_create_question_mcq', 'P', 'EXECUTE', 'role_instructor'),
('sp_create_question_tf', 'P', 'EXECUTE', 'role_instructor'),
('sp_create_question_text', 'P', 'EXECUTE', 'role_instructor'),
('sp_select_students', 'P', 'EXECUTE', 'role_instructor'),
('sp_record_answer', 'P', 'EXECUTE', 'role_student'),
('sp_finalize_exam', 'P', 'EXECUTE', 'role_instructor'),
('sp_manual_mark', 'P', 'EXECUTE', 'role_instructor'),
('sp_search_questions', 'P', 'EXECUTE', 'role_instructor, role_manager'),
('sp_list_exams', 'P', 'EXECUTE', 'role_instructor, role_manager, role_student'),
('sp_student_schedule', 'P', 'EXECUTE', 'role_student'),
('sp_student_results', 'P', 'EXECUTE', 'role_student, role_instructor, role_manager');

declare @ObjName sysname, @ObjType char(1), @GrantType varchar(10), @Roles nvarchar(400);
declare @SchemaName sysname, @SQL nvarchar(max);

declare grant_cursor cursor for
    select ObjName, ObjType, GrantType, Roles from @ObjectsToGrant;

open grant_cursor;
fetch next from grant_cursor into @ObjName, @ObjType, @GrantType, @Roles;

while @@fetch_status = 0
begin
    select @SchemaName = schema_name(schema_id)
    from sys.objects
    where name = @ObjName and type = @ObjType;

    if @SchemaName is not null
    begin
        set @SQL = N'grant ' + @GrantType + N' on ' + quotename(@SchemaName) + N'.' + quotename(@ObjName) + N' to ' + @Roles + N';';
        print @SQL;
        exec sp_executesql @SQL;
    end
    else
    begin
        print 'Skipping ' + @ObjName + ' — object not found.';
    end

    fetch next from grant_cursor into @ObjName, @ObjType, @GrantType, @Roles;
end

close grant_cursor;
deallocate grant_cursor;

--------------------------------------------------------------------------------
-- daily backup job (sql server agent required)
--------------------------------------------------------------------------------
-- create a simple proc that does a full backup to a folder
create procedure BackupFull
    @backup_dir nvarchar(260) = N'F:\DEPI\technical\MS_SQL_Server\SQL_Project\SQL' 
as
begin
    set nocount on;
    declare @file nvarchar(400) =
        @backup_dir + N'\examinationsystem_full_' +
        convert(nvarchar(8), getdate(), 112) + '_' +
        replace(convert(nvarchar(8), getdate(), 108),':','') + N'.bak';

    declare @sql nvarchar(max) =
        N'backup database examinationsystem to disk = N''' + @file + N''' with init, compression;';
    exec (@sql);
end;
go

--------------------------------------------------------------------------------