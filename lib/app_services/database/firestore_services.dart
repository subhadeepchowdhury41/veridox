import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app_models/assignment_model.dart';

class FirestoreServices {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<Assignment>> getAssignments() {
    final _uid = _auth.currentUser!.uid;
    print(_uid);

    return _firestore
        .collection('fv')
        .where('name', isEqualTo: 'Shubhadepp chowdhary')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Assignment.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  // Below two functions are used for getting complete assignment from firebase
  Future<Map<String, dynamic>> getAssignmentById(String id) async {
    final snapshot = await _firestore.collection('assignments').doc(id).get();
    return snapshot as Map<String, dynamic>;
  }

  // for getting the form data as json
  Future<Map<String, dynamic>> getFormDataById(String id) async {
    final snapshot = await _firestore
        .collection('assignments')
        .doc(id)
        .collection('form_data')
        .get();
    return snapshot.docs.first as Map<String, dynamic>;
  }
}
