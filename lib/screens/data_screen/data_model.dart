class Data_Model {
  Data_Model({this.data});
  List<UserData>? data;
  factory Data_Model.fromJson(json) {
    var datas = List.generate(json.keys.toList().length,
        (index) => [json.values.toList()[index], json.keys.toList()[index]]);
    return Data_Model(
        data: List<UserData>.from(datas.map((json) => UserData.fromJson(json)))
            .toList());
  }
}

class UserData {
  UserData(
      {this.id, this.date, this.inTime, this.outTime, this.calories, this.key});
  String? id;
  String? date;
  String? inTime;
  String? outTime;
  String? calories;
  String? key;

  factory UserData.fromJson(json) {
    return UserData(
        id: json[0]['id'],
        date: json[0]['date'],
        inTime: json[0]['in_time'],
        outTime: json[0]['out_time'],
        calories: json[0]['calories'],
        key: json[1]);
  }
}
