class ControlsModel {
  ControlsModel({required this.area, required this.areaId});
  List<Switches>? area;
  List<String>? areaId;
  factory ControlsModel.fromJson(Map<Object?, Object?> json) {
    return ControlsModel(
        area: List<Switches>.from(json.values.map(
                (json) => Switches.fromJson(json as Map<Object?, Object?>)))
            .toList(),
        areaId: json.keys.map((key) => key as String).toList());
  }
}

class Switches {
  Switches({required this.switchId, required this.switchStates});
  List<int>? switchStates;
  List<String>? switchId;
  factory Switches.fromJson(Map<Object?, Object?> json) {
    return Switches(
        switchStates: json.values.map((json) => json as int).toList(),
        switchId: json.keys.map((key) => key as String).toList());
  }
}
