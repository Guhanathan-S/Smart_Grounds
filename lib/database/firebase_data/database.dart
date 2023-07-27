import 'package:firebase_database/firebase_database.dart';
import '/screens/bookings/model/booking_model.dart';
import '../../screens/event_screen/eventDataModel.dart';
import 'userData.dart';

class DataBase {
  DatabaseReference database = FirebaseDatabase.instance.ref();

  /// Add Gym Record
  Future<void> addGymReocrd(
      {String? name,
      String? date,
      // int? condition,
      String? image,
      int? count,
      onSuccess,
      onError}) async {
    var gymData = database.child('records/gym_equipments');
    gymData.push().set({
      "equipment_name": name,
      "installed_date": date,
      // "condition": condition,
      "count": count,
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

  /// Remove Booked Grounds
  Future<void> removeBookedGround(sportName) async {
    database.child('booking/$sportName').onValue.forEach((element) {
      element.snapshot.children.forEach((element) {
        var data = BookingData.fromJson(element.value);
        DateTime eventTime = DateTime.parse(data.bookedDate.toString() +
            "${data.endTime!.split(" ")[1] == "AM" && (data.endTime!.split(":")[0].substring(0, 1) == '0') ? " 0" : " "}" +
            "${(int.parse(data.endTime!.split(":")[0]) + (data.endTime!.split(" ")[1] == "PM" ? 12 : 0)).toString()}:${data.endTime!.split(" ")[0].split(":")[1]}");
        if (DateTime.now().isAfter(eventTime)) {
          database.child('booking/$sportName/${element.key}').remove();
        }
      });
    });
  }

  /// Remove Old Events
  Future<void> removeOldEvent() async {
    database.child('events').onValue.forEach((element) {
      List<EventData> event =
          EventModel.fromJson(element.snapshot.value).eventData!;
      event.forEach((data) {
        DateTime eventTime = DateTime.parse(data.date.toString() +
            "${data.endTime!.split(" ")[1] == "AM" && (data.endTime!.split(":")[0].substring(0, 1) == '0') ? " 0" : " "}" +
            "${(int.parse(data.endTime!.split(":")[0]) + (data.endTime!.split(" ")[1] == "PM" ? 12 : 0)).toString()}:${data.endTime!.split(" ")[0].split(":")[1]}");

        bool isAvailable =
            DateTime.now().subtract(Duration(days: 7)).isAfter(eventTime);
        if (isAvailable) {
          database.child('events/${data.eventId}').remove();
        }
      });
    });
  }

  /// Update Calories Details
  Future<String> updateCalories(
      {required int calories,
      required int totalTime,
      required String key}) async {
    await database.ref
        .child('users_data/${UserDataBase.userDetails.registerNumber}/$key')
        .update(
            {'calories': calories.toInt(), 'time': '${totalTime.toInt()} min'});
    return '';
  }

  // check for device tokens and Add
  Future<void> registerDeviceTokens(deviceToken) async {
    print('registering the device');
    String type = UserDataBase.userDetails.userType == 'others'
        ? 'external_users'
        : 'internal_users';
    DataSnapshot dataSnapshot =
        await database.ref.child('device_tokens/$type').get();
    if (dataSnapshot.exists) {
      Query query = database
          .child('device_tokens/$type')
          .orderByValue()
          .equalTo(deviceToken);
      DatabaseEvent databaseEvent = await query.once();
      DataSnapshot snapshot = databaseEvent.snapshot;
      print(snapshot.value);
      if (!snapshot.exists) {
        await database.ref.child('device_tokens/$type').push().set(deviceToken);
      } else {
        print("snapshot data is exists");
      }
    } else {
      await database.ref.child('device_tokens/$type').push().set(deviceToken);
    }
  }
}
