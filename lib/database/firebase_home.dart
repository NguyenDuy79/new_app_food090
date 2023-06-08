// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHome {
  final CollectionReference _kitchenCollection =
      FirebaseFirestore.instance.collection('kitchen');

  Future<List<QueryDocumentSnapshot>> getKitchenFromFirestore() async {
    var kitchen = await _kitchenCollection.get();
    return kitchen.docs;
  }

  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('product');
  Future<List<QueryDocumentSnapshot>> getProductFromFirestore() async {
    var product = await _productCollection.get();
    return product.docs;
  }
}
