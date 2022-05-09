import 'package:flutter/material.dart';

import '../../core/managers/network/network_manager.dart';

class DbManagerProvider extends ChangeNotifier {
  String username = '';
  String departmentId = '';
  String studentId = '';
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> instructors = [];
  List<Map<String, dynamic>> grades = [];
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> instructorCourses = [];
  List<Map<String, dynamic>> instructorStudents = [];
  List<Map<String, dynamic>> instructorClassrooms = [];
  List<Map<String, dynamic>> allCourses = [];
  List<Map<String, dynamic>> studentCourses = [];
  List<Map<String, dynamic>> searchedCourses = [];
  List<Map<String, dynamic>> filteredCourses = [];
  List<Map<String, dynamic>> gradeAverages = [];

  void setUsername(Map<String, dynamic> map) async {
    username = map.containsKey('username') ? map['username'] : '';
    departmentId = map.containsKey('department_ID') ? map['department_ID'] : '';
    studentId = map.containsKey('student_ID') ? map['student_ID'] : '';
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getStudents();
    return students = res['students'] is List<dynamic>
        ? (res['students'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getInstructors() async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getInstructors();
    return instructors = res['instructors'] is List<dynamic>
        ? (res['instructors'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getGrades(String studentId) async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getGrades(studentId);
    return grades = res['grades'] is List<dynamic>
        ? (res['grades'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getCourses(
      String instructorUsername) async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getCourses(instructorUsername);
    return courses = res['courses'] is List<dynamic>
        ? (res['courses'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getInstructorCourses(
      String instructorUsername) async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getInstructorCourses(instructorUsername);
    return instructorCourses = res['courses'] is List<dynamic>
        ? (res['courses'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getInstructorStudents(
      String instructorUsername, String courseId) async {
    final Map<String, dynamic> res = await NetworkManager.instance
        .getInstructorStudents(instructorUsername, courseId);
    return instructorStudents = res['students'] is List<dynamic>
        ? (res['students'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getInstructorClassrooms(
      int timeSlot) async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getInstructorClassrooms(timeSlot);
    return instructorClassrooms = res['classrooms'] is List<dynamic>
        ? (res['classrooms'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getAllCourses() async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getAllCourses();
    return allCourses = res['courses'] is List<dynamic>
        ? (res['courses'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getStudentCourses(String studentId) async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getStudentCourses(studentId);
    return studentCourses = res['courses'] is List<dynamic>
        ? (res['courses'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> searchCourse(String text) async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.searchCourse(text);
    return searchedCourses = res['courses'] is List<dynamic>
        ? (res['courses'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> filterCourse(String departmentId,
      String campus, String minCredits, String maxCredits) async {
    final Map<String, dynamic> res = await NetworkManager.instance
        .filterCourses(departmentId, campus, minCredits, maxCredits);
    return filteredCourses = res['courses'] is List<dynamic>
        ? (res['courses'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getGradeAverage(String courseId) async {
    final Map<String, dynamic> res =
        await NetworkManager.instance.getGradeAverage(courseId);
    return gradeAverages = res['grades'] is List<dynamic>
        ? (res['grades'] as List<dynamic>)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList()
        : [];
  }
}
