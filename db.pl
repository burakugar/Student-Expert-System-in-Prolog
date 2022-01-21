:- dynamic student/3.
:- dynamic course/8.
:- dynamic room/4.
%knowledge database

% lesson,id,lecturer id,capacity,hour, smart_board, projector, number of enrolled student
course(math,108,9000,20,12,not_smart_board,projector,1).
course(chemistry,101,9000,30,11,smart_board,projector,1).
course(physics,102,9001,25,8,smart_board,not_projector,1).

% id,lessons,projector choice,smartboard choice
instructor(9000,[chemistry,math],not_smart_board,projector).
instructor(9001,[physics],smart_board,not_projector).
% id,lessons,handicapped or not
student(1001,[math,physics,chemistry],unhandicapped).
student(1002,[physics,chemistry],unhandicapped).
student(1003,[chemistry],handicapped).

% enrolling the created students to related classes
enroll(1001,math,108).
enroll(1001,physics,102).
enroll(1001,chemistry,101).
enroll(1002,chemistry,101).
enroll(1002,physics,102).
enroll(1003,chemistry,101).

% id,capacity
room(z23,40,smart_board,not_projector).
room(z11,45,smart_board,projector).
room(z06,30,not_smart_board,not_projector).

% occupancy for room, lecture id and hour
occupancy(z23,108,12).
occupancy(z11,101,11).
occupancy(z23,102,8).

%rules

%schedule(ID,L,C_ID) :- enroll(ID,L,C_ID), where(Class, P), when(Class,T).

%usage(P, T) :- where(Class,P), when(Class,T).

%conflicting of times
timeconflict(Course1, Course2) :-
    course(Course1,_,_,_,T1,_,_,_),
    course(Course2,_,_,_,T2,_,_,_),
    T1==T2.

%finding available room for the given class
find_room(Course1) :-
    course(_,Course1,_,COURSE_CAP,_,COURSE_SMART,COURSE_PRO,_),
    room(ROOM_NAME,ROOM_CAP,SMART,PRO),
    instructor(_,_,SMART1,PRO1),
    SMART1==SMART,
    COURSE_SMART== SMART, % comparing instructor choice for the room
    COURSE_PRO== PRO,
    PRO==PRO1,
    COURSE_CAP =< ROOM_CAP, % check whether the capacity is enough or not
    print(ROOM_NAME).
%check which room can be assigned to which classes
assing_room(Course1) :-
    course(_,Course1,_,COURSE_CAP,_,COURSE_SMART,COURSE_PRO,_),
    room(ROOM_NAME,ROOM_CAP,SMART,PRO),
    instructor(_,_,SMART1,PRO1),
    COURSE_SMART== SMART, % comparing instructor choice for the room
    COURSE_PRO== PRO,
    SMART1==SMART,
    PRO==PRO1,
    COURSE_CAP =< ROOM_CAP, % check whether the capacity is enough or not
    print(ROOM_NAME),nl,
    print(Course1).
%check for a student can be enrolled to a given class
assign_student(Studentid,Courseid) :-  
    course(_,Courseid,_,COURSE_CAP,_,_,_,COURSE_ENROLLED),
    student(Studentid,_,_),
    COURSE_CAP > COURSE_ENROLLED.
%check which classes a student can be assigned

which_can_be_assigned(Studentid) :-
    student(Studentid,_,_),
    course(_,COURSE_ID,_,COURSE_CAP,_,_,_,COURSE_ENROLLED),
    COURSE_CAP > COURSE_ENROLLED,
    write(COURSE_ID).

addstudent(Id,Courses,H):- assertz(student(Id,Courses,H)).
addcourse(Lesson,Id,LecturerId,Capacity,Hours,Board,Projector,_):-assertz(course(Lesson,Id,LecturerId,Capacity,Hours,Board,Projector,_)).
addroom(Id,Capacity,Board,Projector):-assertz(room(Id,Capacity,Board,Projector)).