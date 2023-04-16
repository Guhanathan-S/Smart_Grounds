class Controls_Model {
  Controls_Model({this.gym});
  List<Switches>? gym;
  factory Controls_Model.fromJson(json) {
    return Controls_Model(
        gym: List<Switches>.from(
            json.values.map((json) => Switches.fromJson(json))).toList());
  }
}

class Switches {
  Switches({this.switchh});
  int? switchh;
  factory Switches.fromJson(json) {
    return Switches(switchh: json["light_one"]);
  }
}
