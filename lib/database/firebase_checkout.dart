import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCheckout {
  final CollectionReference _promoCodeCollection =
      FirebaseFirestore.instance.collection('promo code');
  CollectionReference get promoCodeCollection => _promoCodeCollection;
  Future<List<QueryDocumentSnapshot>> getPromoCode() async {
    var promoCode = await _promoCodeCollection.get();
    return promoCode.docs;
  }

  final CollectionReference _shippingPromoCodeCollection =
      FirebaseFirestore.instance.collection('Shipping promo code');
  Future<List<QueryDocumentSnapshot>> getShippingPromoCode() async {
    var shippingPromoCode = await _shippingPromoCodeCollection.get();
    return shippingPromoCode.docs;
  }
}
