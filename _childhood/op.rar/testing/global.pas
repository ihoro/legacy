unit global;

interface

const

  // registry:

  keyMain: string =
    '\software\OIVSoft\Testing System\';
  regServerName: string =
    'server';
  regDataBasePath: string =
    'db path';    

  // users:

  usrAdmin: string = 'SYSDBA';
  usrTeacher: string = 'TEACHER';
  usrStudent: string = 'STUDENT';

  // info params:

  infGlobalCounter: string = 'Global Counter';
  infGlobalCounter2: string = 'Global Counter2';

  // tables name:

  tnStudents: string = 'students';
  tnTests: string = 'tests';
  tnInfo: string = 'info';
  tnPlans: string = 'plans';

  // default texts:

  txtEditMode: string = 'View Mode';
  txtViewMode: string = 'Edit Mode';
  txtCountStudents: string = 'Всего студентов в базе: ';
  txtCountPlans: string = 'Всего планов работ в базе: ';
  txtDefaultTestsCount: string = 'Всего тестов в базе: ';
  txtDefaultLogin: string = 'login';
  txtDefaultTestName: string = '';
  txtDefaultTestTableName: string = 'test_';
  txtDefaultWorksTableName: string = 'student_';
  txtDefaultQuestion: string = 'Вопрос N ';
  txtDefaultQuestionSplitter: string = '$@$';
  txtDefaultQuestionTrueAsks: string = '';
  txtAreYouSure: string = 'Вы уверены?';
  txtSaveChanges: string = 'Сохранить изменения?';
  txtConfirmation: string = 'Подтверждение';
  txtInformation: string = 'Информация';
  txtGoTest: string = 'Готовы начать тестирование?';
  txtWorks05: string = 'У Вас запланировано %d тестирований:';
  txtWorks1: string = 'У Вас запланировано %d тестирование:';
  txtWorks234: string = 'У Вас запланировано %d тестирования:';
  txtYourResult: string = 'Ваша оценка: ';
  txtResults: string = 'Результаты тестов:';

  // table's headers:

  hNomer: string = 'N';
  hStudentLogin: string = 'Логин';
  hStudentFirstName: string = 'Имя';
  hStudentMiddleName: string = 'Отчество';
  hStudentLastName: string = 'Фамилия';
  hStudentGroup: string = 'Группа';
  hStudentCourse: string = 'Курс';
  hTestName: string = 'Тема';
  hPlanDate: string = 'Дата';
  hPlanTime: string = 'Время';
  hSubject: string = 'Предмет';
  hTeacher: string = 'Преподаватель';
  hResult: string = 'Оценка';


  // default numbers:

  numDefaultTestTime: Integer = 0;
  numDefaultQuestionTime: Integer = 0;
  numDefaultStudentCourse: Integer = 1;
  numStudentsCol0Width: Integer = 40;
  numStudentsCol1Width: Integer = 70;
  numStudentsCol2Width: Integer = 150;
  numStudentsCol3Width: Integer = 150;
  numStudentsCol4Width: Integer = 150;
  numStudentsCol5Width: Integer = 70;
  numStudentsCol6Width: Integer = 40;
  numTestsCol0Width: Integer = 40;
  numTestsCol1Width: Integer = 325;
  numPlansCol0Width: Integer = 40;
  numPlansCol1Width: Integer = 70;
  numPlansCol2Width: Integer = 250;
  numPlansCol3Width: Integer = 65;
  numPlansCol4Width: Integer = 55;
  numWorksCol0Width: Integer = 65;
  numWorksCol1Width: Integer = 70;
  numWorksCol2Width: Integer = 170;
  numWorksCol3Width: Integer = 120;
  numWorksCol4Width: Integer = 55;
  numResultsByStudentCol0Width: Integer = 300;
  numResultsByStudentCol1Width: Integer = 45;

  // SQL-scirpts:

  sqlGetResults: string =
    'select wrk_test_name,wrk_result from %s '+
    'order by wrk_test_name;';
  sqlGetWorkByTestName: string =
    'select wrk_test_name from %s '+
    'where wrk_test_name=:test_name;';
  sqlInsertIntoWorks: string =
    'insert into %s('+
      'wrk_no,'+
      'wrk_test_name,'+
      'wrk_result,'+
      'wrk_asks) '+
    'values('+
      ':no,'+
      ':test_name,'+
      ':result,'+
      ':asks);';
  sqlGetCount: string =
    'select count(%s) from %s;';
  sqlSetGrant: string =
    'grant %s on %s to %s;';
  sqlGetTestByName: string =
    'select tst_time,tst_table_name from tests '+
    'where tst_name=:name;';
  sqlDeleteWorks: string =
    'drop table %s;';
  sqlGetWorksByNo: string =
    'select std_works from %s '+
    'where std_no=:no;';
  sqlNewWorks: string =
    'create table %s('+
      'wrk_no int not null,'+
      'wrk_test_name varchar(100),'+
      'wrk_result int,'+
      'wrk_asks varchar(15),'+
      'primary key (wrk_no));';
  sqlGetPlansByGroup: string =
    'select pln_date,tst_subject,pln_test_name,tst_teacher,pln_time from %s,%s '+
    'where pln_group=:group AND tst_name=pln_test_name AND pln_date>=:date '+
    'order by pln_date;';
  sqlCommandOnConnect: string =
    'select std_no from students '+
    'where std_no=1;';
  sqlGetUserByLogin: string =
    'select * from %s '+
    'where std_login=:login;';
  sqlDeleteSelectedPlans: string =
    'delete from %s '+
    'where pln_no=:no;';
  sqlAddNewPlan: string =
    'insert into %s('+
      'pln_no,'+
      'pln_group,'+
      'pln_test_name) '+
    'values('+
      ':no,'+
      ':group,'+
      ':test_name);';
  sqlViewPlans: string =
    'select * from %s order by pln_no;';
  sqlGetTableNameByNo: string =
    'select * from %s '+
    'where tst_no=:no;';
  sqlUpdateQuestionTime: string =
    'update %s set '+
      'test_time=:time '+
    'where test_no=:no;';
  sqlUpdateQuestionTrueAsks: string =
    'update %s set '+
      'test_true_asks=:true_asks '+
    'where test_no=:no;';
  sqlUpdateQuestionAsks: string =
    'update %s set '+
      'test_asks=:asks '+
    'where test_no=:no;';
  sqlUpdateQuestion: string =
    'update %s set '+
      'test_question=:question '+
    'where test_no=:no;';
  sqlDeleteQuestion: string =
    'delete from %s '+
    'where test_no=:no;';
  sqlViewQuestion: string =
    'select * from %s '+
    'where test_no=:no;';
  sqlAddNewQuestion: string =
    'insert into %s('+
      'test_no,'+
      'test_question,'+
      'test_asks,'+
      'test_true_asks,'+
      'test_time) '+
    'values('+
      ':no,'+
      ':question,'+
      ':asks,'+
      ':true_asks,'+
      ':time);';
  sqlUpdateTestName: string =
    'update %s set tst_name=:tst_name '+
    'where tst_table_name=:tst_table_name;';
  sqlUpdateTimeTest: string =
    'update %s set tst_time=:tst_time '+
    'where tst_table_name=:tst_table_name;';
  sqlUpdateTestSubject: string =
    'update %s set tst_subject=:tst_subject '+
    'where tst_table_name=:tst_table_name;';
  sqlUpdateTestTeacher: string =
    'update %s set tst_teacher=:tst_teacher '+
    'where tst_table_name=:tst_table_name;';
  sqlViewTest: string =
    'select * from %s '+
    'order by test_no;';
  sqlNewTest: string =
    'create table %s('+
      'test_no int not null,'+
      'test_question varchar(2000),'+
      'test_asks varchar(1000),'+
      'test_true_asks varchar(20),'+
      'test_time int,'+
      'primary key (test_no));';
  sqlDeleteTest: string =
    'drop table %s;';
  sqlGetCountRowsInTable: string =
    'select count(%s) from %s;';
  sqlGetInfo: string =
    'select inf_str_value,inf_int_value from %s '+
    'where inf_param=:inf_param;';
  sqlSetInfo: string =
    'update info set '+
      'inf_str_value=:inf_str_value,'+
      'inf_int_value=:inf_int_value '+
    'where inf_param=:inf_param;';
  sqlViewAllStudents: string =
    'select * from %s order by std_no;';
  sqlGetAllTests: string =
    'select * from %s order by tst_no;';
  sqlSaveModifyStudents: string =
    'update %s set '+
      'std_no=:std_no,'+
      'std_login=:login,'+
      'std_first_name=:first_name,'+
      'std_middle_name=:middle_name,'+
      'std_last_name=:last_name,'+
      'std_group=:group,'+
      'std_course=:course '+
    'where std_no=:no;';
  sqlSaveModifyPlans: string =
    'update %s set '+
      'pln_no=:pln_no,'+
      'pln_group=:group,'+
      'pln_test_name=:test_name,'+
      'pln_date=:date,'+
      'pln_time=:time '+
    'where pln_no=:no;';
  sqlDeleteSelectedStudents: string =
    'delete from %s '+
    'where std_no=:no;';
  sqlDeleteTests: string =
    'delete from %s '+
    'where tst_table_name=:table_name;';
  sqlAddNewStudent: string =
    'insert into %s('+
      'std_no,'+
      'std_login,'+
      'std_first_name,'+
      'std_middle_name,'+
      'std_last_name,'+
      'std_group,'+
      'std_course,'+
      'std_works) '+
    'values('+
      ':no,'+
      ':login,'+
      ':first_name,'+
      ':middle_name,'+
      ':last_name,'+
      ':group,'+
      ':course,'+
      ':works);';
  sqlAddNewTest: string =
    'insert into %s('+
      'tst_no,'+
      'tst_name,'+
      'tst_subject,'+
      'tst_teacher,'+
      'tst_table_name,'+
      'tst_time) '+
    'values('+
      ':no,'+
      ':name,'+
      ':subject,'+
      ':teacher,'+
      ':table_name,'+
      ':time);';
  sqlSortStudents: string =
    'update %s set '+
      'std_no=:std_no '+
    'where std_no=:no;';
  sqlSortTests: string =
    'update %s set '+
      'tst_no=:tst_no '+
    'where tst_no=:no;';
  sqlSortTest: string =
    'update %s set '+
      'test_no=:test_no '+
    'where test_no=:no;';
  sqlSortPlans: string =
    'update %s set '+
      'pln_no=:pln_no '+
    'where pln_no=:no;';

  // other:

  Numer_set: set of Char = ['0','1','2','3','4','5','6','7','8','9'];

var
  pswStudent: string;

implementation

end.
