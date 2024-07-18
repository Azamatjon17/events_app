import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFirestorageService {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<String?> uploadImage(File imageFile,String path) async {
    try {
      // Create a reference to the Firebase Storage location
      Reference storageReference = _firebaseStorage.ref().child('$path.jpg');

      // Upload the file
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
