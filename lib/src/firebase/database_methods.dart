import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sonicity/src/models/report.dart';
import 'package:sonicity/utils/contants/enums.dart';

class DatabaseMethods extends GetxController{
  Future<void> uploadReport({required Report report, required Views views}) async {
    await FirebaseFirestore.instance
    .collection(FirebaseCollections.report.toText)
    .doc(DateTime.now().toString())
    .set(report.toJson());
  }
}