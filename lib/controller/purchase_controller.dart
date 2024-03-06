import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_foot_client/controller/login_controller.dart';
import 'package:new_foot_client/model/user/user.dart';
import 'package:new_foot_client/pages/home_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PurchaseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();
  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  @override
  void onInit() async {
    orderCollection = firestore.collection('orders');
    super.onInit();
  }

  submitOrder(
      {required String item,
      required String description,
      required double price}) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    // print('$itemName $orderPrice $orderAddress');

    Razorpay _razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': price * 100,
      'name': item,
      'description': description,
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId);
    Get.snackbar('Success', 'Payment is Successful', colorText: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Failed', 'Error $response', colorText: Colors.red);
  }

  Future<void> orderSuccess({required String? transactionId}) async {
    User? loginUse = Get.find<LoginController>().loginUser;
    try {
      if (transactionId != null) {
        DocumentReference docRef = await orderCollection.add({
          'customer': loginUse?.name ?? '',
          'phone': loginUse?.number ?? '',
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionId': transactionId,
          'dateTime': DateTime.now().toString(),
        });
        // print('Order Successfully ${docRef.id}');
        showOrderSuccessDialog(docRef.id);
        Get.snackbar('Sucess', 'Order created successfully',
            colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'Please fill all Field', colorText: Colors.red);
      }
    } catch (e) {
      // print('Failed to register User: $e');
      Get.snackbar('Error', 'Failed to create Order', colorText: Colors.red);
    }
  }

  void showOrderSuccessDialog(String orderId) {
    Get.defaultDialog(
        title: 'Order Success',
        content: Text('Your OrderId is $orderId'),
        confirm: ElevatedButton(
            onPressed: () {
              Get.off(const HomePage());
            },
            child: const Text('Close')));
  }
}
