import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseUsers {
  CollectionReference cartCollection(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart');
  }

  Future<List<QueryDocumentSnapshot>> getCartFirestore(String uid) async {
    var cart = await cartCollection(uid).get();
    return cart.docs;
  }

  CollectionReference orderCollection(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('order');
  }

  Future<List<QueryDocumentSnapshot>> getOrderFirestore(String uid) async {
    var order = await orderCollection(uid).get();
    return order.docs;
  }
}
