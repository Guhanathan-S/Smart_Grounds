class Controls_Model {
  Controls_Model({required this.area, required this.areaId});
  List<Switches>? area;
  List<String>? areaId;
  factory Controls_Model.fromJson(Object? json) {
    json as Map<Object?, Object?>;
    return Controls_Model(
        area: List<Switches>.from(
            json.values.map((json) => Switches.fromJson(json))).toList(),
        areaId: json.keys.map((key) => key as String).toList());
  }
}

class Switches {
  Switches({required this.switchStates, required this.switchId});
  List<ControlData>? switchStates;
  List<String>? switchId;
  factory Switches.fromJson(Object? json) {
    json as Map<Object?, Object?>;
    return Switches(
        switchStates:
            json.values.map((json) => ControlData.fromJson(json)).toList(),
        switchId: json.keys.map((key) => key as String).toList());
  }
}

class ControlData {
  ControlData({required this.switchState});
  int? switchState;
  factory ControlData.fromJson(json) => ControlData(switchState: json);
}
