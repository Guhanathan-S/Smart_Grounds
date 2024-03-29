class RecordsModel {
  RecordsModel({
    this.gymEquipments,
    this.sportsItems,
  });
  List<GymEquipments>? gymEquipments;
  SportsItems? sportsItems;

  factory RecordsModel.fromJson(Map<Object?, Object?> json) {
    return RecordsModel(
        gymEquipments: (json["gym_equipments"] as Map<Object? , Object?>).values
            .map((json) => GymEquipments.fromJson(json))
            .toList(),
        sportsItems: SportsItems.fromJson(json["sports_items"]));
  }
}

class SportsItems {
  SportsItems({
    this.cricket,
    this.footBall,
    this.volleyBall,
    this.tennis,
    this.badminton,
  });
  List<SportsItem>? cricket;
  List<SportsItem>? volleyBall;
  List<SportsItem>? footBall;
  List<SportsItem>? tennis;
  List<SportsItem>? badminton;

  factory SportsItems.fromJson(json) {
    return SportsItems(
        cricket: List<SportsItem>.from(
                json["cricket"].values.toList().map((json) => SportsItem.fromJson(json)))
            .toList(),
        footBall: List<SportsItem>.from(
                json["football"].values.toList().map((json) => SportsItem.fromJson(json)))
            .toList(),
        volleyBall: List<SportsItem>.from(json["volleyball"]
            .values
            .toList()
            .map((json) => SportsItem.fromJson(json))).toList(),
        tennis: List<SportsItem>.from(
                json["tennis"].values.toList().map((json) => SportsItem.fromJson(json)))
            .toList(),
        badminton: List<SportsItem>.from(json["badminton"].values.toList().map((json) => SportsItem.fromJson(json))).toList());
  }
}

class GymEquipments {
  GymEquipments({
    this.equipmentName,
    this.installedDate,
    this.image,
    this.condition,
  });
  String? equipmentName;
  String? installedDate;
  String? image;
  int? condition;

  factory GymEquipments.fromJson(json) => GymEquipments(
      equipmentName: json["equipment_name"],
      installedDate: json["installed_date"],
      condition: json["condition"],
      image: json['image']);
}

class SportsItem {
  SportsItem({this.itemName, this.itemCount, this.purchasedDate, this.image});
  String? itemName;
  String? itemCount;
  String? purchasedDate;
  String? image;

  factory SportsItem.fromJson(json) {
    return SportsItem(
        itemName: json["item_name"],
        itemCount: json["item_count"],
        purchasedDate: json['purchased_date'],
        image: json['image']);
  }
}
