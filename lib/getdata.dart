import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Data {
  Future<DocumentSnapshot<Map<String, dynamic>>> getuser() async{
    var current = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance;
    var uid = current!.uid;

    return await db.collection("users").doc(uid).get();
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getuserwithid(uid) async{
    var db = FirebaseFirestore.instance;
    return await db.collection("users").doc(uid).get();
  }
}