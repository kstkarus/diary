class ScheduleJson {
  String? prepodNameEnc;
  String? dayDate;
  String? audNum;
  String? disciplName;
  String? buildNum;
  String? orgUnitName;
  String? dayTime;
  String? dayNum;
  String? potok;
  String? prepodName;
  String? disciplNum;
  String? orgUnitId;
  String? prepodLogin;
  String? disciplType;
  String? disciplNameEnc;

  ScheduleJson({
    this.prepodNameEnc,
    this.dayDate,
    this.audNum,
    this.disciplName,
    this.buildNum,
    this.orgUnitName,
    this.dayTime,
    this.dayNum,
    this.potok,
    this.prepodName,
    this.disciplNum,
    this.orgUnitId,
    this.prepodLogin,
    this.disciplType,
    this.disciplNameEnc,
  });

  ScheduleJson.fromJson(Map<String, dynamic> json) {
    prepodNameEnc = json['prepodNameEnc'];
    dayDate = json['dayDate'];
    audNum = json['audNum'];
    disciplName = json['disciplName'];
    buildNum = json['buildNum'];
    orgUnitName = json['orgUnitName'];
    dayTime = json['dayTime'];
    dayNum = json['dayNum'];
    potok = json['potok'];
    prepodName = json['prepodName'];
    disciplNum = json['disciplNum'];
    orgUnitId = json['orgUnitId'];
    prepodLogin = json['prepodLogin'];
    disciplType = json['disciplType'];
    disciplNameEnc = json['disciplNameEnc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prepodNameEnc'] = prepodNameEnc;
    data['dayDate'] = dayDate;
    data['audNum'] = audNum;
    data['disciplName'] = disciplName;
    data['buildNum'] = buildNum;
    data['orgUnitName'] = orgUnitName;
    data['dayTime'] = dayTime;
    data['dayNum'] = dayNum;
    data['potok'] = potok;
    data['prepodName'] = prepodName;
    data['disciplNum'] = disciplNum;
    data['orgUnitId'] = orgUnitId;
    data['prepodLogin'] = prepodLogin;
    data['disciplType'] = disciplType;
    data['disciplNameEnc'] = disciplNameEnc;
    return data;
  }
}