import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';

class DatabaseMethods extends GetxController{
  Future<void> uploadReport({required Report report, required Routes views}) async {
    await FirebaseFirestore.instance
    .collection(FirebaseCollections.report.toText)
    .doc(DateTime.now().toString())
    .set(report.toJson());
  }
}