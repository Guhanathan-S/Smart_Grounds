import 'package:firebase_database/firebase_database.dart';

class DataBase {
  DatabaseReference database = FirebaseDatabase.instance.ref();

  /// Add Gym Record
  Future<void> addGymReocrd(
      {name, date, condition, image, onSuccess, onError}) async {
    var gymData = database.child('records/gym_equipments');
    gymData.push().set({
      "equipment_name": name,
      "installed_date": date,
      "condition": condition,
      "image": image
    }).then((value) {
      Future.delayed(Duration(seconds: 2)).then((value) => onSuccess());
    }).catchError((e) => onError());
  }

  /// Add sports Record
  Future<void> addSportsRecord(
      {itemName, count, sport, image, date, onSuccess, onError}) async {
    var sportsItems = database.ref.child("records/sports_items");
    sportsItems
        .child(sport)
        .push()
        .set({
          "item_name": itemName,
          "item_count": count,
          'image': image,
          'purchased_date': date
        })
        .then((value) =>
            Future.delayed(Duration(seconds: 2)).then((value) => onSuccess()))
        .catchError((e) => onError());
  }

  /// Add Events
  Future<void> addEvent(
      {eventName,
      team1,
      team2,
      place,
      organizer,
      startTime,
      endTime,
      date}) async {
    var events = database.child('events');
    events.push().set({
      "event_name": eventName,
      "organizer": organizer,
      "team1": team1,
      "team2": team2,
      "place": place,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
    });
  }

  /// Update Event
  Future<void> updateEvent({team1Score, team2Score, id, wonBy}) async {
    var event = database.child("events");
    event.child(id).update({
      "team1_score": team1Score,
      "team2_score": team2Score,
      "won_by": wonBy,
    });
  }

  /// Book Grounds
  Future<void> bookGround({booker, sportName, startTime, endTime, date}) async {
    var events = database.child('booking/$sportName');
    events.push().set({
      "booked_by": booker,
      "sport_name": sportName,
      "booked_date": date,
      "start_time": startTime,
      "end_time": endTime,
    });
  }
}
