import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CarouselService {
  String carouselId = DateTime.now().microsecondsSinceEpoch.toString();
  uploadCarouselImageAndSavePublishedDate(File file) async {
    String imageDownloadUrl = await uploadCarouselImage(file);
    savePublishedDate(imageDownloadUrl);
  }

  Future<String> uploadCarouselImage(mFileImage) async {
    final Reference reference =
        FirebaseStorage.instance.ref().child("Carousels");
    UploadTask uploadTask =
        reference.child("Carousel_$carouselId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  savePublishedDate(downloadUrl) {
    final carouselRef = FirebaseFirestore.instance.collection("Carousels");
    carouselRef.doc(carouselId).set({
      "carouselId": carouselId,
      "publishedDate": DateTime.now(),
      "carouselImgUrl": downloadUrl,
    });
  }

  deleteItem(String carouselId) {
    final carouselRef = FirebaseFirestore.instance.collection("Carousels");
    carouselRef.doc(carouselId).delete();
  }
}
