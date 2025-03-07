import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<dynamic>> getGroups(String group) async {
  final url = Uri.parse("https://api.pocket-kai.ru/group/suggest?group_name=$group");

  final headers = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'text/plain'
  };

  try {
    final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      List<dynamic> groupsDecode = jsonDecode(response.body);

      return groupsDecode;
    }
  } catch(e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return [];
}

Future<List<dynamic>> getStaff(String staffName) async {
  if (staffName.length < 3) {
    return [];
  }

  final staffUrl = Uri.parse("https://kai.ru/for-staff/raspisanie");
  final staff = {
    "p_p_id": "pubLecturerSchedule_WAR_publicLecturerSchedule10",
    "p_p_lifecycle": "2",
    "p_p_state": "normal",
    "p_p_mode": "view",
    "p_p_resource_id": "getLecturersURL",
    "p_p_cacheability": "cacheLevelPage",
    "p_p_col_id": "column-1",
    "p_p_col_count": "1",
    "query": staffName,
  };

  try {
    final response = await http.post(staffUrl, body: staff);

    if (response.statusCode == 200) {
      List<dynamic> staffDecode = jsonDecode(response.body);

      return staffDecode;
    }
  } catch(e) {
    //nothing ig
  }

  return [];
}

Future<Map<String, dynamic>> getStaffSchedule(String staffLogin) async {
  final staffUrl = Uri.parse("https://kai.ru/for-staff/raspisanie");
  final staff = {
    "p_p_id": "pubLecturerSchedule_WAR_publicLecturerSchedule10",
    "p_p_lifecycle": "2",
    "p_p_state": "normal",
    "p_p_mode": "view",
    "p_p_resource_id": "schedule",
    "p_p_cacheability": "cacheLevelPage",
    "p_p_col_id": "column-1",
    "p_p_col_count": "1",
    "prepodLogin": staffLogin,
  };

  try {
    final response = await http.post(staffUrl, body: staff);

    if (response.statusCode == 200) {
      Map<String, dynamic> staffScheduleDecode = jsonDecode(response.body);

      return staffScheduleDecode;
    }
  } catch(e) {
    //
  }

  return jsonDecode('{"0":[]}');
}

Future<List<dynamic>> getExams(String groupID) async {
  final examsUrl = Uri.parse("https://kai.ru/raspisanie");
  final exams = {
    "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
    "p_p_lifecycle": "2",
    "p_p_state": "normal",
    "p_p_mode": "view",
    "p_p_resource_id": "examSchedule",
    "p_p_cacheability": "cacheLevelPage",
    "p_p_col_id": "column-1",
    "p_p_col_count": "1",
    "groupId": groupID,
  };

  try {
    final response = await http.post(examsUrl, body: exams).timeout(const Duration(seconds: 2));

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("cachedExams", response.body);

      List<dynamic> examsDecode = jsonDecode(response.body);
      return examsDecode;
    }
  } catch (e) {
    //
  }

  final prefs = await SharedPreferences.getInstance();
  String cachedSchedule = prefs.getString("cachedExams") ?? "[]";

  List<dynamic> examsDecode = jsonDecode(cachedSchedule);
  return examsDecode;
}

Future<Map<String, dynamic>> getSchedule(String groupID) async {
  final groupsUrl = Uri.parse("https://api.pocket-kai.ru/group/by_name/$groupID/schedule/week");
  // final groups = {
  //   "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
  //   "p_p_lifecycle": "2",
  //   "p_p_state": "normal",
  //   "p_p_mode": "view",
  //   "p_p_resource_id": "schedule",
  //   "p_p_cacheability": "cacheLevelPage",
  //   "p_p_col_id": "column-1",
  //   "p_p_col_count": "1",
  //   "groupId": groupID,
  // };

  final headers = {
    'Content-Type': 'text/plain'
  };

  try {
    final response = await http.get(groupsUrl, headers: headers).timeout(const Duration(seconds: 2));

    if (response.statusCode == 200) {
      var body = utf8.decode(response.bodyBytes);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("cachedSchedule", body);

      Map<String, dynamic> groupsDecode = jsonDecode(body);
      return groupsDecode;
    }
  } catch (e) {
    if (kDebugMode) {
      print('error: $e');
    }
  }

  final prefs = await SharedPreferences.getInstance();
  String cachedSchedule = prefs.getString("cachedSchedule") ?? "{'0':[]}";

  Map<String, dynamic> groupsDecode = jsonDecode(cachedSchedule);
  return groupsDecode;
}