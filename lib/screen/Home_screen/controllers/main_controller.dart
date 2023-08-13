import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:new_ap/config/firebase_api.dart';
import 'package:new_ap/model/cart_model.dart';
import 'package:new_ap/model/product_model.dart';
import 'package:new_ap/model/rate_and_comment_model.dart';

import '../../../common_app/common_widget.dart';
import '../../../config/app_another.dart';
import '../../../model/kitchen_model.dart';
import '../../../model/promo_model.dart';
import '../../../model/user_model.dart';

class MainController extends GetxController {
  final Rx<List<CartModel>> _cart = Rx<List<CartModel>>([]);

  List<CartModel> get cart => _cart.value;
  final Rx<List<ProductModel>> product = Rx<List<ProductModel>>([]);

  final Rx<UserModel> _user = UserModel(
    id: '',
    email: '',
    image: '',
    mobile: '',
    userName: '',
  ).obs;
  UserModel get user => _user.value;
  final Rx<List<KitchenModel>> _kitchenModel = Rx<List<KitchenModel>>([]);
  List<KitchenModel> get kitchenModel => _kitchenModel.value;
  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;
  final RxDouble _scrollPosition = 0.0.obs;
  double get scrollPosition => _scrollPosition.value;
  double getAppbarHeight = AppBar().preferredSize.height;
  final _pageController = PageController();
  PageController get pageController => _pageController;
  final Rx<List<PromoCode>> _promoCode = Rx<List<PromoCode>>([]);
  List<PromoCode> get promoCode => _promoCode.value;
  final Rx<List<ShippingPromoCode>> _shippingPromoCode =
      Rx<List<ShippingPromoCode>>([]);
  List<ShippingPromoCode> get shippingPromoCode => _shippingPromoCode.value;
  final Rx<List<KitchenModel>> _kitchenSearch = Rx<List<KitchenModel>>([]);
  List<KitchenModel> get kitchenSearch => _kitchenSearch.value;

  final Rx<List<RateAndCommentModel>> rateAndComment =
      Rx<List<RateAndCommentModel>>([]);

  int getLenght(int lenght) {
    if (lenght % 2 == 0) {
      return lenght;
    } else {
      return lenght + 1;
    }
  }

  @override
  void onInit() {
    _scrollController.addListener(() {
      _scrollListen();
    });
    if (AppAnother.userAuth != null) {
      _kitchenModel.bindStream(kitchenStream());
      _cart.bindStream(AppAnother.cartStream(AppAnother.userAuth!.uid));
      _user.bindStream(getUser(AppAnother.userAuth!.uid));
      _promoCode.bindStream(AppAnother.promoCodeStream());
      _shippingPromoCode.bindStream(AppAnother.shippingPromoCode());
      _historySearch.bindStream(kitchenSearchStream(AppAnother.userAuth!.uid));
    }
    super.onInit();
  }

  _scrollListen() {
    _scrollPosition.value = _scrollController.position.pixels;
  }

  Stream<UserModel> getUser(String uid) {
    return FirebaseApi().userCollection.doc(uid).snapshots().map((event) {
      UserModel userStream =
          UserModel.fromJson(event.data() as Map<String, dynamic>);
      return userStream;
    });
  }

  Stream<List<RateAndCommentModel>> getReview(String kitchenId) {
    return FirebaseApi()
        .kitchenReviewCollection(kitchenId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) {
      List<RateAndCommentModel> listReview = [];
      if (event.docs.isNotEmpty) {
        if ((event.docs[0].data() as Map<String, dynamic>)['quantity'] !=
            null) {
          for (int i = 0; i < event.docs.length; i++) {
            listReview.add(RateAndCommentModel.fromJson(
                (event.docs[i].data() as Map<String, dynamic>)));
          }
        }
      }

      return listReview;
    });
  }

  Stream<List<ProductModel>> getProduct(String id) {
    return FirebaseApi().productCollection(id).snapshots().map((event) {
      List<ProductModel> listCartStream = [];
      for (int i = 0; i < event.docs.length; i++) {
        listCartStream.add(ProductModel.formJson(
            event.docs[i].data() as Map<String, dynamic>));
      }

      return listCartStream;
    });
  }

  Stream<List<KitchenModel>> kitchenStream() {
    return FirebaseApi()
        .kitchenCollection
        .snapshots()
        .map((QuerySnapshot query) {
      List<KitchenModel> listCartStream = [];
      for (int i = 0; i < query.docs.length; i++) {
        listCartStream.add(KitchenModel.formJson(
            query.docs[i].data() as Map<String, dynamic>));
      }

      return listCartStream;
    });
  }

  Stream<List<SearchModel>> kitchenSearchStream(String uid) {
    return FirebaseApi()
        .kitchenSearchCollection(uid)
        .orderBy('id', descending: true)
        .limit(10)
        .snapshots()
        .map((event) {
      List<SearchModel> listSearchStream = [];
      for (var item in event.docs) {
        listSearchStream
            .add(SearchModel.fromJson(item.data() as Map<String, dynamic>));
      }
      return listSearchStream;
    });
  }

  double getHeight(double width, int length) {
    double count = 0;
    if (length % 2 == 0) {
      count = (length / 2) * 160;
    } else {
      count = ((length + 1) / 2) * 160;
    }
    if ((width - 400) > count) {
      return (width - 400);
    } else {
      return count;
    }
  }

  String getRate() {
    double count = 0;
    if (rateAndComment.value.isNotEmpty) {
      for (int i = 0; i < rateAndComment.value.length; i++) {
        count += rateAndComment.value[i].rate.toDouble();
      }
      return ((count / (rateAndComment.value.length))).toStringAsFixed(1);
    } else {
      return '0';
    }
  }

  double ratioStart(int number) {
    if (rateAndComment.value.isNotEmpty) {
      int count = 0;
      if (number == 1) {
        for (int i = 0; i < rateAndComment.value.length; i++) {
          if (rateAndComment.value[i].rate == 1) {
            count = count + 1;
          }
        }

        return count / rateAndComment.value.length;
      } else if (number == 2) {
        for (int i = 0; i < rateAndComment.value.length; i++) {
          if (rateAndComment.value[i].rate == 2) {
            count++;
          }
        }
        return count / rateAndComment.value.length;
      } else if (number == 3) {
        for (int i = 0; i < rateAndComment.value.length; i++) {
          if (rateAndComment.value[i].rate == 3) {
            count++;
          }
        }
        return count / rateAndComment.value.length;
      } else if (number == 4) {
        for (int i = 0; i < rateAndComment.value.length; i++) {
          if (rateAndComment.value[i].rate == 4) {
            count++;
          }
        }
        return count / rateAndComment.value.length;
      } else {
        for (int i = 0; i < rateAndComment.value.length; i++) {
          if (rateAndComment.value[i].rate == 5) {
            count++;
          }
        }
        return count / rateAndComment.value.length;
      }
    } else {
      return 0.0;
    }
  }

  String getBooked(int index) {
    String value = '';
    for (int i = 0; i < rateAndComment.value[index].quantity.length; i++) {
      if (rateAndComment.value[index].quantity[i] == 1) {
        value = value + rateAndComment.value[index].name[i];
      } else {
        value =
            '$value${rateAndComment.value[index].name[i]}x${rateAndComment.value[index].quantity[i]} ';
      }
    }
    return value;
  }

  likeMethod(String id, int index, BuildContext ctx) async {
    if (AppAnother.userAuth != null) {
      try {
        if (rateAndComment.value[index].listLike
            .contains(AppAnother.userAuth!.uid)) {
          final List<String> newList = [];
          newList.add(AppAnother.userAuth!.uid);

          await FirebaseApi()
              .kitchenReviewCollection(id)
              .doc(rateAndComment.value[index].id)
              .update({
            'list like': FieldValue.arrayRemove(newList),
            'like': rateAndComment.value[index].like - 1
          });
        } else {
          final List<String> newList = rateAndComment.value[index].listLike;

          newList.add(AppAnother.userAuth!.uid);
          await FirebaseApi()
              .kitchenReviewCollection(id)
              .doc(rateAndComment.value[index].id)
              .update({
            'list like': FieldValue.arrayUnion(newList),
            'like': rateAndComment.value[index].like + 1
          });
        }
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();

        CommonWidget.showErrorDialog(ctx);
      }
    }
  }

  // SearchScreen
  //final Rx<List<String>> _kitchenName = Rx<List<String>>([]);
  final Rx<List<String>> _kitchenName = Rx<List<String>>([]);
  List<String> get kitchenName => _kitchenName.value;
  final RxBool _isCheck = false.obs;
  bool get isCheck => _isCheck.value;
  final Rx<List<SearchModel>> _historySearch = Rx<List<SearchModel>>([]);
  List<String> historySearch = [];
  final _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;
  TextEditingController textEditing = TextEditingController();
  final RxBool _isMain = true.obs;
  bool get isMain => _isMain.value;
  final RxBool _reload = false.obs;
  bool get reload => _reload.value;
  RxInt itemCount = 0.obs;
  getTrueIsMain() {
    _isMain.value = true;
  }

  getFalseIsMain() {
    _isMain.value = false;
  }

  Future<void> submitQuerySearch(String query, BuildContext ctx) async {
    Timestamp timestamp = Timestamp.now();

    if (AppAnother.userAuth != null) {
      try {
        if (historySearch.length <= 10) {
          await FirebaseApi()
              .kitchenSearchCollection(AppAnother.userAuth!.uid)
              .doc(timestamp.toString())
              .set({'id': timestamp, 'search value': query.trim()}).catchError(
                  (e) => throw e);
        } else {
          Timestamp id =
              _historySearch.value[_historySearch.value.length - 1].id;
          await FirebaseApi()
              .kitchenSearchCollection(AppAnother.userAuth!.uid)
              .doc(timestamp.toString())
              .set({'id': timestamp, 'search value': query.trim()}).then(
                  (value) => FirebaseApi()
                      .kitchenSearchCollection(AppAnother.userAuth!.uid)
                      .doc(id.toString())
                      .delete());
        }
      } on PlatformException catch (err) {
        Get.back();
        log(err.message.toString());

        CommonWidget.showErrorDialog(ctx);
      } catch (err) {
        Get.back();

        CommonWidget.showErrorDialog(ctx);
      }
    }
  }

  getValueHistorySearch() {
    historySearch = [];
    for (var item in _historySearch.value) {
      if (!historySearch.contains(item.query)) {
        historySearch.add(item.query);
      }
    }
  }

  changeStatusEmpty() {
    if (textEditing.text.trim() == '') {
      _isCheck.value = false;
    } else {
      _isCheck.value = true;
    }
  }

  getListQuery(String query) {
    _reload.value = true;
    _kitchenSearch.value = [];

    for (var item in _kitchenModel.value) {
      if (item.name.toLowerCase().contains(query.toLowerCase())) {
        _kitchenSearch.value.add(item);
      }
    }
    _reload.value = false;
  }

  getKitchenSearch(List<Favorite> favorite) {
    _kitchenSearch.value = [];
    for (var item in _kitchenModel.value) {
      for (var value in favorite) {
        if (value.id == item.id) {
          _kitchenSearch.value.add(item);
        }
      }
    }
  }

  getSuggest(String value) {
    _kitchenName.value = [];
    for (var item in kitchenModel) {
      if (item.name.toLowerCase().contains(value.toLowerCase())) {
        _kitchenName.value.add(item.name);
      }
    }
  }
}
