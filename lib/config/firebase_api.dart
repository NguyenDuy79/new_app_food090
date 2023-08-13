import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_ap/config/app_string.dart';

class FirebaseApi {
  final CollectionReference<Map<String, dynamic>> _userCollection =
      FirebaseFirestore.instance.collection(AppString.users);

  CollectionReference<Map<String, dynamic>> get userCollection =>
      _userCollection;

  Future<DocumentSnapshot> getUser(String uid) async {
    var user = await _userCollection.doc(uid).get();
    return user;
  }

  CollectionReference favoriteKitchenCollection(String id) {
    return FirebaseFirestore.instance
        .collection('kitchen')
        .doc(id)
        .collection(AppString.favorite);
  }

  CollectionReference cartCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.cart);
  }

  CollectionReference favoriteCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.favorite);
  }

  CollectionReference kitchenSearchCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.kitchenSearch);
  }

  CollectionReference orderSearchCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.orderSearch);
  }

  CollectionReference orderNowSearchCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.partner)
        .doc(uid)
        .collection(AppString.orderNowSearch);
  }

  CollectionReference orderHistorySearchCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.partner)
        .doc(uid)
        .collection(AppString.orderHistorySearch);
  }

  CollectionReference chatSearchCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.messageSearch);
  }

  CollectionReference chatCollection(String uid, String id) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.chat)
        .doc(id)
        .collection(AppString.content);
  }

  CollectionReference chatProfileCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.chat);
  }

  Future<List<QueryDocumentSnapshot>> getCartFirestore(String uid) async {
    var cart = await cartCollection(uid).get();
    return cart.docs;
  }

  Future<List<QueryDocumentSnapshot>> getKitchenReview(String kitchenId) async {
    var review = await kitchenReviewCollection(kitchenId).get();
    return review.docs;
  }

  CollectionReference orderCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.order);
  }

  CollectionReference reviewCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.users)
        .doc(uid)
        .collection(AppString.kitchenReview);
  }

  Future<List<QueryDocumentSnapshot>> getOrderFirestore(String uid) async {
    var order = await orderCollection(uid).get();
    return order.docs;
  }

  final CollectionReference _kitchenCollection =
      FirebaseFirestore.instance.collection(AppString.kitchen);
  CollectionReference get kitchenCollection => _kitchenCollection;
  CollectionReference kitchenReviewCollection(String id) {
    return _kitchenCollection.doc(id).collection(AppString.kitchenReview);
  }

  final CollectionReference _promoCodeCollection =
      FirebaseFirestore.instance.collection(AppString.promoCode);

  CollectionReference get promoCodeCollection => _promoCodeCollection;

  CollectionReference productCollection(String kitchenId) {
    return FirebaseFirestore.instance
        .collection(AppString.kitchen)
        .doc(kitchenId)
        .collection(AppString.menu);
  }

  final CollectionReference _shippingPromoCodeCollection =
      FirebaseFirestore.instance.collection(AppString.shippingPromoCode);
  CollectionReference get shippingPromoCodeCollection =>
      _shippingPromoCodeCollection;

  final CollectionReference _ordersNow =
      FirebaseFirestore.instance.collection(AppString.orderNow);
  CollectionReference get orderNow => _ordersNow;

  final CollectionReference _partner =
      FirebaseFirestore.instance.collection(AppString.partner);

  CollectionReference get partner => _partner;

  CollectionReference orderPartner(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.partner)
        .doc(uid)
        .collection(AppString.orderProgress);
  }

  CollectionReference orderHistoryPartner(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.partner)
        .doc(uid)
        .collection(AppString.orderCompleted);
  }

  CollectionReference chatCollectionPartner(String uid, String id) {
    return FirebaseFirestore.instance
        .collection(AppString.partner)
        .doc(uid)
        .collection(AppString.chat)
        .doc(id)
        .collection(AppString.content);
  }

  CollectionReference chatProfileCollectionPartner(String uid) {
    return FirebaseFirestore.instance
        .collection(AppString.partner)
        .doc(uid)
        .collection(AppString.chat);
  }
}
