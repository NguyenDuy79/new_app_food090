import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePartner {
  final CollectionReference _ordersNow =
      FirebaseFirestore.instance.collection('orders now');
  CollectionReference get ordersNow => _ordersNow;
  Future<List<QueryDocumentSnapshot>> getOrdersNow() async {
    var value = await _ordersNow.get();
    return value.docs;
  }
}
