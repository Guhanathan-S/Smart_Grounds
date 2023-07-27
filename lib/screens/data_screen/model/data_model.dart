class DataModel {
  DataModel({this.data});
  List<UserData>? data;
  factory DataModel.fromJson(Map<Object?, Object?> json) {
    var datas = List.generate(json.keys.toList().length,
        (index) => [json.values.toList()[index], json.keys.toList()[index]]);
    return DataModel(
        data: List<UserData>.from(datas.map((json) => UserData.fromJson(json)))
            .toList());
  }
}

class UserData {
  UserData(
      {this.id,
      this.date,
      this.inTime,
      this.outTime,
      this.calories,
      this.totCal,
      this.key,
      this.time});
  String? id;
  String? date;
  String? inTime;
  String? outTime;
  int? calories;
  int? totCal;
  String? key;
  String? time;

  factory UserData.fromJson(json) {
    return UserData(
      id: json[0]['id'],
      date: json[0]['date'],
      inTime: json[0]['in_time'],
      outTime: json[0]['out_time'],
      calories: json[0]['calories'],
      totCal: json[0]['totCal'],
      time: json[0]['time'],
      key: json[1],
    );
  }
}
