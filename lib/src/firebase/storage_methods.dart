import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sonicity/utils/contants/constants.dart';

class StorageMethods extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // * : Adding feedback screenshot to firebase Storage
  Future<String> uploadReportScreenshot(Uint8List file, Routes views) async {
    Reference ref = _storage.ref().child(StorageCollections.report.toText).child(views.toText).child(DateTime.now().toString());
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}