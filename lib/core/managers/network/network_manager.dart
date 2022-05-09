import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../constants/network/network_constants.dart';

class NetworkManager {
  NetworkManager._init() {
    _service = Dio(BaseOptions(
        headers: {HttpHeaders.contentTypeHeader: _contentType},
        baseUrl: NetworkConstants.apiBase));
  }
  static final NetworkManager _instance = NetworkManager._init();

  late Dio _service;
  final String _contentType = 'application/json';
  static NetworkManager get instance => _instance;

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String userType,
  }) async {
    try {
      final Response<dynamic> res = await _service.post(
        '/user/login',
        data: jsonEncode({
          "username": username,
          "password": password,
          "user_type": userType
        }),
      );
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
    // TODO: BACK KAPALIYKEN HATA DÜŞMÜYOR
  }

  Future<Map<String, dynamic>> getStudents() async {
    try {
      final Response<dynamic> res = await _service.get('/dbManager/student');
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInstructors() async {
    try {
      final Response<dynamic> res = await _service.get('/dbManager/instructor');
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getGrades(String studentId) async {
    try {
      final Response<dynamic> res = await _service
          .get('/dbManager/grade', queryParameters: {"id": studentId});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCourses(String instructorUsername) async {
    try {
      final Response<dynamic> res = await _service.get('/dbManager/course',
          queryParameters: {"username": instructorUsername});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateTitle(
      String instructorUsername, String newTitle) async {
    try {
      final Response<dynamic> res = await _service.put('/dbManager/instructor',
          data:
              jsonEncode({"username": instructorUsername, "title": newTitle}));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCourseName(
      String courseId, String newCourseName) async {
    try {
      final Response<dynamic> res = await _service.put('/instructor/course',
          data: jsonEncode({"course_ID": courseId, "name": newCourseName}));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteStudent(String studentId) async {
    try {
      final Response<dynamic> res = await _service
          .delete('/dbManager/student', queryParameters: {"id": studentId});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> enroll(String studentId, String courseId) async {
    try {
      final Response<dynamic> res = await _service.post(
          '/student/course/enroll',
          data: jsonEncode({"student_ID": studentId, "course_ID": courseId}));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addStudent({
    required String studentId,
    required String username,
    required String password,
    required String name,
    required String surname,
    required String email,
    required String departmentId,
  }) async {
    try {
      final Response<dynamic> res = await _service.post('/dbManager/student',
          data: jsonEncode({
            "student_ID": studentId,
            "username": username,
            "password": password,
            "name": name,
            "surname": surname,
            "email": email,
            "department_ID": departmentId,
          }));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addInstructor({
    required String title,
    required String username,
    required String password,
    required String name,
    required String surname,
    required String email,
    required String departmentId,
  }) async {
    try {
      final Response<dynamic> res = await _service.post('/dbManager/instructor',
          data: jsonEncode({
            "title": title,
            "username": username,
            "password": password,
            "name": name,
            "surname": surname,
            "email": email,
            "department_ID": departmentId,
          }));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInstructorCourses(
      String instructorUsername) async {
    try {
      final Response<dynamic> res = await _service.get('/instructor/course',
          queryParameters: {"username": instructorUsername});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInstructorClassrooms(int timeSlot) async {
    try {
      final Response<dynamic> res = await _service
          .get('/instructor/classroom', queryParameters: {"slot": timeSlot});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getInstructorStudents(
      String instructorUsername, String courseId) async {
    try {
      final Response<dynamic> res = await _service.get('/instructor/student',
          queryParameters: {
            "username": instructorUsername,
            "course_ID": courseId
          });
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> filterCourses(String departmentId, String campus,
      String minCredits, String maxCredits) async {
    try {
      final Response<dynamic> res =
          await _service.get('/student/course/filter', queryParameters: {
        "department_ID": departmentId,
        "campus": campus,
        "min_credits": minCredits,
        "max_credits": maxCredits,
      });
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAllCourses() async {
    try {
      final Response<dynamic> res = await _service.get('/student/course/all');
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStudentCourses(String studentId) async {
    try {
      final Response<dynamic> res = await _service.get(
          '/student/course/enrolled',
          queryParameters: {"student_ID": studentId});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addPrerequisite(
      String prerequisiteId, String courseId, String username) async {
    try {
      final Response<dynamic> res =
          await _service.post('/instructor/prerequisite',
              data: jsonEncode({
                "prerequisite_ID": prerequisiteId,
                "course_ID": courseId,
                "instructor_username": username,
              }));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> searchCourse(String text) async {
    try {
      final Response<dynamic> res = await _service
          .get('/student/course', queryParameters: {"name": text});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addCourse({
    required String courseId,
    required String name,
    required String credits,
    required String classroomId,
    required String timeSlot,
    required String quota,
    required String departmentId,
    required String instructorUsername,
  }) async {
    try {
      final Response<dynamic> res = await _service.post('/instructor/course',
          data: jsonEncode({
            "course_ID": courseId,
            "name": name,
            "credits": credits,
            "classroom_ID": classroomId,
            "time_slot": timeSlot,
            "quota": quota,
            "department_ID": departmentId,
            "instructor_username": instructorUsername,
          }));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> giveGrade(
    String courseId,
    String studentId,
    String username,
    String grade,
  ) async {
    try {
      final Response<dynamic> res = await _service.post('/instructor/grade',
          data: jsonEncode({
            "course_ID": courseId,
            "instructor_username": username,
            "student_ID": studentId,
            "grade": grade,
          }));
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getGradeAverage(String courseId) async {
    try {
      final Response<dynamic> res = await _service
          .get('/dbManager/gradeAverage', queryParameters: {"id": courseId});
      return jsonDecode(res.toString());
    } on DioError {
      rethrow;
    }
  }
}
