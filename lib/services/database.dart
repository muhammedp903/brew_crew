import 'package:brewcrew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brewcrew/models/brew.dart';

class Database {

  final String uid;
  Database({this.uid});

  final CollectionReference brewCollection = Firestore.instance.collection("brews");

  Future updateUserData(String sugars, String name, int strength) async{
    return await brewCollection.document(uid).setData({
      "sugars": sugars,
      "name": name,
      "strength": strength,
    });
  }

  List<Brew> _brewListFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Brew(
        name: doc.data["name"] ?? "",
        strength: doc.data["strength"] ?? 100,
        sugars: doc.data["sugars"] ?? "0",
      );
    }).toList();
  }

  UserData _userDataFromSnapshot (DocumentSnapshot snapshot){
    return UserData (
      uid: uid,
      name: snapshot.data["name"],
      sugars: snapshot.data["sugars"],
      strength: snapshot.data["strength"],
    );
  }

  Stream <List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  Stream <UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

}