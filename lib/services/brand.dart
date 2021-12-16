import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  void createBrad(String name) {
    var id = Uuid();
    String brandId = id.v1();
    _firebaseFirestore
        .collection("brands")
        .doc(brandId)
        .set({'brandName': name});
  }
}
