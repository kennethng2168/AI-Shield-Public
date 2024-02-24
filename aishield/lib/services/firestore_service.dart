import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/Detection.dart';

class FirestoreService {
  String? docId;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addReport(
    Detection detection,
  ) async {
    docId = firestore.collection("detection").doc().id;
    await firestore
        .collection("detection")
        .doc(docId)
        .set(detection.toMap(docId!));
  }

  Future<Detection?> getDetectionInfo(String uid) async {
    final doc = await firestore.collection("detection").doc().get();

    return doc.exists ? Detection.fromMap(doc.data()!) : null;
  }

  Stream<List<Detection>> getDetection() {
    return firestore
        .collection("detection") // Get Collection
        .snapshots() // Get Snapshots and loop through
        .map((snapshot) => snapshot.docs.map((doc) {
              // Loop through docs
              final d = doc.data(); // Each doc get the data
              return Detection.fromMap(d); // Convert it into a map
            }).toList()); // Construct a list out of the products mapping
  }

  Future<int> getDetectionCount() async {
    QuerySnapshot querySnapshot = await firestore.collection('detection').get();
    return querySnapshot.size;
  }

  Future<void> deleteDetection(String id) async {
    return await firestore.collection("detection").doc(id).delete();
  }
}
