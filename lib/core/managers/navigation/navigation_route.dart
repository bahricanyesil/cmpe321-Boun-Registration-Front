import 'package:flutter/material.dart';

import '../../../features/db-manager/add_user.dart';
import '../../../features/db-manager/db_manager_home_screen.dart';
import '../../../features/db-manager/grade_average.dart';
import '../../../features/db-manager/instructor_courses.dart';
import '../../../features/db-manager/student_grades.dart';
import '../../../features/db-manager/update_title.dart';
import '../../../features/instructor/add_course.dart';
import '../../../features/instructor/add_prerequisite.dart';
import '../../../features/instructor/give_grade.dart';
import '../../../features/instructor/instructor_classrooms.dart';
import '../../../features/instructor/instructor_home.dart';
import '../../../features/instructor/instructor_students.dart';
import '../../../features/instructor/update_course_name.dart';
import '../../../features/login/login_screen.dart';
import '../../../features/student/filter_course.dart';
import '../../../features/student/search_course.dart';
import '../../../features/student/student_home.dart';
import 'navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    final Map<String, dynamic>? mappedArgs =
        args.arguments is Map<String, dynamic>?
            ? args.arguments as Map<String, dynamic>?
            : {
                "instructor_username": "1",
                "student_ID": "1",
                "old_title": "title",
                "index": 0,
                "user_type": "",
                "course_ID": "1",
                "time_slot": 1,
                "old_name": "name",
              };
    switch (args.name) {
      case NavigationConstants.login:
        return normalNavigate(const LoginScreen());
      case NavigationConstants.dbManager:
        return normalNavigate(DbManagerHome(index: mappedArgs?['index'] ?? 0));
      case NavigationConstants.studentHome:
        return normalNavigate(StudentHome(index: mappedArgs?['index'] ?? 0));
      case NavigationConstants.instructorHome:
        return normalNavigate(InstructorHome(index: mappedArgs?['index'] ?? 0));
      case NavigationConstants.addCourse:
        return normalNavigate(const AddCourse());
      case NavigationConstants.searchCourse:
        return normalNavigate(const SearchCourse());
      case NavigationConstants.filterCourse:
        return normalNavigate(const FilterCourse());
      case NavigationConstants.addStudent:
        return normalNavigate(
            AddUser(userType: mappedArgs?['user_type'] ?? ''));
      case NavigationConstants.instructorStudents:
        return normalNavigate(
            InstructorStudents(courseId: mappedArgs?['course_ID'] ?? ''));
      case NavigationConstants.gradeAverage:
        return normalNavigate(
            GradeAverage(courseId: mappedArgs?['course_ID'] ?? ''));
      case NavigationConstants.addPrerequisite:
        return normalNavigate(
            AddPrerequisite(courseId: mappedArgs?['course_ID'] ?? ''));
      case NavigationConstants.instructorClassrooms:
        return normalNavigate(
            InstructorClassrooms(timeSlot: mappedArgs?['time_slot'] ?? ''));
      case NavigationConstants.studentGrades:
        return normalNavigate(
            StudentGrades(studentId: mappedArgs?['student_ID'] ?? ''));
      case NavigationConstants.giveGrade:
        return normalNavigate(GiveGrade(
            studentId: mappedArgs?['student_ID'] ?? '',
            courseId: mappedArgs?['course_ID'] ?? ''));
      case NavigationConstants.instructorCourses:
        return normalNavigate(InstructorCourses(
            instructUsername: mappedArgs?['instructor_username'] ?? ''));
      case NavigationConstants.updateTitle:
        return normalNavigate(UpdateTitle(
            instructUsername: mappedArgs?['instructor_username'] ?? '',
            oldTitle: mappedArgs?['old_title'] ?? ''));
      case NavigationConstants.updateCourseName:
        return normalNavigate(UpdateCourseName(
            courseId: mappedArgs?['course_ID'] ?? '',
            oldName: mappedArgs?['old_name'] ?? ''));
      default:
        return normalNavigate(const LoginScreen());
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) => MaterialPageRoute(
        builder: (BuildContext context) => widget,
      );
}
