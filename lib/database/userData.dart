import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataBase {
  final String? uid;
  UserDataBase({this.uid});

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future createUserData(
      {String? name,
      String? type,
      String? registerId,
      int? weight,
      String? number}) async {
    if (type!.toLowerCase() == 'others')
      return await users.doc(uid).set({
        'name': name,
        'type': type,
        'numbers': number!,
      });
    return await users.doc(uid).set({
      'name': name,
      'type': type,
      'register_number': registerId,
      'weight': weight
    });
  }

  Future<String> getUserType() async {
    String type = "";
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    if (documentSnapshot.exists) {
      type = documentSnapshot['type'];
    }
    return type;
  }
}
