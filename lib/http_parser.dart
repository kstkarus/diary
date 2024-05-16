import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> checkGroup(String group) async {
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

  final response = await http.post(groupsUrl, body: groups);

  if (response.statusCode == 200) {
    List<dynamic> groupsDecode = jsonDecode(response.body);

    return groupsDecode.any((e) => e['group'] == group);
  }

  return false;
}