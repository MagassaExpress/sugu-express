import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  CollectionReference annonces() {
    return firestore.collection('annonces');
  }

  CollectionReference utilisateurs() {
    return firestore.collection('utilisateurs');
  }

  CollectionReference favoris() {
    return firestore.collection('favoris');
  }
}