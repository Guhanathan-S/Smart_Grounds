class BookingModel {
  BookingModel(
      {this.cricket,
      this.footBall,
      this.volleyBall,
      this.tennis,
      this.badminton,
      this.basketBall});
  List<BookingData>? cricket;
  List<BookingData>? volleyBall;
  List<BookingData>? footBall;
  List<BookingData>? tennis;
  List<BookingData>? badminton;
  List<BookingData>? basketBall;
  factory BookingModel.fromJson(json) {
    return BookingModel(
      cricket: json['cricket'] != null
          ? List<BookingData>.from(json["cricket"]
              .values
              .toList()
              .map((json) => BookingData.fromJson(json))).toList()
          : [],
      footBall: json['football'] != null
          ? List<BookingData>.from(json["football"]
              .values
              .toList()
              .map((json) => BookingData.fromJson(json))).toList()
          : [],
      volleyBall: json['volleyball'] != null
          ? List<BookingData>.from(json["volleyball"]
              .values
              .toList()
              .map((json) => BookingData.fromJson(json))).toList()
          : [],
      tennis: json['tennis'] != null
          ? List<BookingData>.from(json["tennis"]
              .values
              .toList()
              .map((json) => BookingData.fromJson(json))).toList()
          : [],
      badminton: json['badminton'] != null
          ? List<BookingData>.from(json["badminton"]
              .values
              .toList()
              .map((json) => BookingData.fromJson(json))).toList()
          : [],
      basketBall: json['basketball'] != null
          ? List<BookingData>.from(json["basketball"]
              .values
              .toList()
              .map((json) => BookingData.fromJson(json))).toList()
          : [],
    );
  }
}

class BookingData {
  BookingData(
      {this.sportName,
      this.bookedBy,
      this.bookedDate,
      this.startTime,
      this.endTime});
  String? sportName;
  String? bookedBy;
  String? bookedDate;
  String? startTime;
  String? endTime;

  factory BookingData.fromJson(json) {
    return BookingData(
        sportName: json["sport_name"],
        bookedBy: json['booked_by'],
        bookedDate: json["booked_date"],
        startTime: json['start_time'],
        endTime: json['end_time']);
  }
}
