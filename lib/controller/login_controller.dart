import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_foot_client/model/user/user.dart';
import 'package:new_foot_client/pages/home_page.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;
  GetStorage box = GetStorage();
  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  TextEditingController loginNumberCtrl = TextEditingController();

  bool otpFieldShow = false;
  int? otpSent;
  int? otpEnter;
  User? loginUser;

  @override
  void onReady() {
    try {
      Map<String, dynamic>? user = box.read('loginUser');
      if (user != null) {
        loginUser = User.fromJson(user);
        Get.to(HomePage());
      }

      super.onReady();
    } on Exception catch (e) {
      print(e.toString());
      // TODO
    }
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    // TODO: implement onInit
    super.onInit();
  }

  addUser() {
    try {
      if (otpSent == otpEnter) {
        DocumentReference doc = userCollection.doc();
        User user = User(
          id: doc.id,
          name: registerNameCtrl.text,
          number: int.tryParse(registerNumberCtrl.text),
        );

        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar('Success', "User Added Successfully ",
            colorText: Colors.green);
        registerNameCtrl.clear();
        registerNumberCtrl.clear();
        otpController.clear();
      } else {
        Get.snackbar('Error', "OTP incorrect ", colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  sendOtp() async {
    try {
      if (registerNameCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Please fill your details',
            colorText: Colors.red);
        //to stop continue we need to write return key word here...
        return;
      }
      final random = Random();
      int otp = 1000 + random.nextInt(9000);
      String mobileNumber = registerNumberCtrl.text;
      String url =
          'https://www.fast2sms.com/dev/bulkV2?authorization=6LXiUp2sd8cZhHNgMCxtuBfb10ARDIyPQvw59FzqWYnESo3jOrNKLFm1z0jwvOqX6Hu2rQAx5GUi8D3o&route=otp&variables_values=$otp&flash=0&numbers=$mobileNumber';
      Response response = await GetConnect().get(url);
      print(otp);

      //will send otp and check successfully ot not
      if (response.body['message'][0] == 'SMS sent successfully.') {
        otpFieldShow = true;
        otpSent = otp;
        Get.snackbar('Success', 'Otp Sent Successfully',
            colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'OTP Not sent', colorText: Colors.red);
      }
    } catch (e) {
      print(e);
      // TODO
    } finally {
      update();
    }
  }

  loginWithPhone() async {
    try {
      String phoneNumber = loginNumberCtrl.text;
      if (phoneNumber.isNotEmpty) {
        var querySnapshot = await userCollection
            .where('number', isEqualTo: int.tryParse(phoneNumber))
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;

          // to store data in device like sharedPreference
          box.write('loginUser', userData);
          loginNumberCtrl.clear();
          Get.offAll(HomePage());
          Get.snackbar('Success', 'Login Successfully',
              colorText: Colors.green);
        } else {
          Get.snackbar('Wrong', 'User not found please Register',
              colorText: Colors.red);
        }
      }
    } catch (e) {
      print('Failed to Login $e');
    }
  }
}
