import 'package:firebase_storage/firebase_storage.dart';
import '';

class Storage {
  final storage = FirebaseStorage.instance;

  Future<String> downloadfile(String imagename) async {
    final storageref = FirebaseStorage.instance.ref();
    String Downloadurl =await storageref.child(imagename).getDownloadURL();
    return Downloadurl;
  }
  Future<String> downloadfile2(String imagename) async {
    final storageref = FirebaseStorage.instance.ref();
    String Downloadurl =await storageref.child(imagename).getDownloadURL();
    return Downloadurl;
  }
}