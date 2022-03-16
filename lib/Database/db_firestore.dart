import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Db {
  var firestore = FirebaseFirestore.instance;
  // var uid = FirebaseAuth.instance.currentUser!.uid;

  saveAdminData(data,id) async {
    await firestore.collection('Admin').doc(id).set(data);
  }
}
