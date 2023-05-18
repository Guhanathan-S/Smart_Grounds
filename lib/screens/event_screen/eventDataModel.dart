class EventModel {
  EventModel({this.eventData});
  List<EventData>? eventData;

  factory EventModel.fromJson(json) {
    try {
      List js = List.generate(json.keys.toList().length,
          (index) => [json.keys.toList()[index], json.values.toList()[index]]);
      return EventModel(
          eventData:
              List<EventData>.from(js.map((json) => EventData.fromJson(json))));
    } catch (e) {
      return EventModel(eventData: []);
    }
  }
}

class EventData {
  EventData(
      {this.eventId,
      this.eventName,
      this.organizer,
      this.team1,
      this.team1Score,
      this.team2,
      this.team2Score,
      this.place,
      this.date,
      this.startTime,
      this.endTime,
      this.wonBy});
  String? eventId;
  String? eventName;
  String? organizer;
  String? team1;
  String? team2;
  String? place;
  String? date;
  String? startTime;
  String? endTime;
  String? team1Score;
  String? team2Score;
  String? wonBy;

  factory EventData.fromJson(json) {
    return EventData(
        eventId: json[0],
        eventName: json[1]["event_name"],
        organizer: json[1]["organizer"],
        team1: json[1]["team1"],
        team1Score: json[1]["team1_score"],
        team2: json[1]["team2"],
        team2Score: json[1]["team2_score"],
        place: json[1]["place"],
        date: json[1]["date"],
        startTime: json[1]["start_time"],
        endTime: json[1]["end_time"],
        wonBy: json[1]["won_by"]);
  }
}
