import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _UserDetails {
  late final String _name;
  late final String _type;
  late final String? _number;
  late final String? _registerId;
  late final double? _weight;
  factory _UserDetails.fromJson({required Map<Object?, Object?> json}) {
    return _UserDetails(
      userName: json['name'] as String,
      userType: json['type'] as String,
      userNumber: json['contact_number'] == null
          ? null
          : json['contact_number'] as String,
      userWeight: json['weight'] == null ? null : json['weight'] as double,
      registerNumber: json['register_number'] == null
          ? null
          : json['register_number'] as String,
    );
  }
  _UserDetails(
      {required String userName,
      required String userType,
      required userNumber,
      required registerNumber,
      required userWeight})
      : _name = userName,
        _type = userType,
        _number = userNumber,
        _registerId = registerNumber,
        _weight = userWeight;

  ///This will return the User Name.
  String get userName => _name;

  ///This will return the User Type.
  String get userType => _type.toLowerCase();

  ///This will return the User Mobile Number.
  String? get userNumber => _number;

  ///This will return the User Register Number.
  String? get registerNumber => _registerId;

  ///This will return the User Weight.
  double? get userWeight => _weight;
}

class UserDataBase {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static late String? _uid;
  static FirebaseAuth get auth => _auth;
  static String? get uid => _uid;
  static late DocumentSnapshot _documentSnapshot;
  static late _UserDetails _userDetails;
  static CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  static _UserDetails get userDetails => _userDetails;
  UserDataBase._sharedInstance();
  static final _shared = UserDataBase._sharedInstance();
  factory UserDataBase() => _shared;
  Future createUserData(
      {String? name,
      String? type,
      String? registerId,
      int? weight,
      String? number}) async {
    if (type!.toLowerCase() == 'others') {
      await _users.doc(_uid).set({
        'name': name,
        'type': type,
        'contact_number': number!,
      });
    } else {
      await _users.doc(_uid).set({
        'name': name,
        'type': type,
        'register_number': registerId,
        'weight': weight
      });
    }
    return getUserData();
  }

  static Future<void> getUserData() async {
    _uid = _auth.currentUser!.uid;
    _documentSnapshot = await _users.doc(_uid).get();
    print(_documentSnapshot.data());
    _userDetails = _UserDetails.fromJson(
        json: _documentSnapshot.data() as Map<Object?, Object?>);
  }

  Future<void> setUserWeight({required double userWeight}) async {
    await _users.doc(_uid).update({'weight': userWeight});
    await getUserData();
    return null;
  }
}
