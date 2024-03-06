import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_foot_client/controller/login_controller.dart';
import 'package:new_foot_client/pages/login_page.dart';
import 'package:new_foot_client/widgets/otp_txt_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  final String register = 'Register';
  final String sendOtp = 'Send Otp';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Your Account',
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 29),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: ctrl.registerNameCtrl,
                decoration: InputDecoration(
                    hintText: "Enter your Name",
                    label: Text('Your Name'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: ctrl.registerNumberCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter Your Mobile Number',
                    label: Text('Mobile Number'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 20,
              ),
              OtpTextField(
                otpController: ctrl.otpController,
                visble: ctrl.otpFieldShow,
                onComplete: (otp) {
                  ctrl.otpEnter = int.tryParse(otp ?? '0000');
                  // ctrl.update();
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  ctrl.otpFieldShow ? ctrl.addUser() : ctrl.sendOtp();
                },
                child: Text(ctrl.otpFieldShow ? register : sendOtp),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
