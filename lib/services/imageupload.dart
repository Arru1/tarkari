import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';

class ImgUpload
{
static Future<List<String>> uploadMultipleImages(List<File> imageFiles) async {
  List<String> imageUrls = [];
  for (int i = 0; i < imageFiles.length; i++) {
    String imageUrl = '';
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Reference to the storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference refernceDirImages = referenceRoot.child('ProductImages/');

    Reference referenceImageUpload =
        refernceDirImages.child(uniqueFileName + '_$i.jpg');

    try {
      await referenceImageUpload.putFile(imageFiles[i]);
      imageUrl = await referenceImageUpload.getDownloadURL();
      imageUrls.add(imageUrl);
      print('Image uploaded. URL: $imageUrl');
    } catch (error) {
      print('Error uploading image: $error');
    }
  }
  return imageUrls;
}


}