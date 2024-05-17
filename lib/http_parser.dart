import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<dynamic>> getGroups(String group) async {
  final groupsUrl = Uri.parse("https://kai.ru/raspisanie");
  final groups = {
    "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
    "p_p_lifecycle": "2",
    "p_p_state": "normal",
    "p_p_mode": "view",
    "p_p_resource_id": "getGroupsURL",
    "p_p_cacheability": "cacheLevelPage",
    "p_p_col_id": "column-1",
    "p_p_col_count": "1",
    "query": group,
  };

  try {
    final response = await http.post(groupsUrl, body: groups);

    if (response.statusCode == 200) {
      List<dynamic> groupsDecode = jsonDecode(response.body);

      return groupsDecode;
    }
  } catch(e) {
    //nothing ig
  }

  return [];
}

Future<Map<String, dynamic>>  getCachedSchedule() async {
  final prefs = await SharedPreferences.getInstance();
  String cachedSchedule = prefs.getString("cachedSchedule") ?? "{'0':[]}";

  Map<String, dynamic> groupsDecode = jsonDecode(cachedSchedule);
  return groupsDecode;
}

Future<Map<String, dynamic>> getSchedule(String groupID) async {
  final groupsUrl = Uri.parse("https://kai.ru/raspisanie");
  final groups = {
    "p_p_id": "pubStudentSchedule_WAR_publicStudentSchedule10",
    "p_p_lifecycle": "2",
    "p_p_state": "normal",
    "p_p_mode": "view",
    "p_p_resource_id": "schedule",
    "p_p_cacheability": "cacheLevelPage",
    "p_p_col_id": "column-1",
    "p_p_col_count": "1",
    "groupId": groupID,
  };

  try {
    final response = await http.post(groupsUrl, body: groups);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("cachedSchedule", response.body);

      Map<String, dynamic> groupsDecode = jsonDecode(response.body);
      return groupsDecode;
    }
  } catch (e) {
    //
  }
  return getCachedSchedule();
}