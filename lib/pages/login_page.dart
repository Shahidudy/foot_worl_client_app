import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_foot_client/controller/login_controller.dart';
import 'package:new_foot_client/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.purple[50]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to New Foot",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 29,
                    color: Colors.purple),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: ctrl.loginNumberCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_android),
                    label: Text('Mobile Number'),
                    hintText: 'Enter your Mobile Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  ctrl.loginWithPhone();
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Get.to(RegisterPage());
                  },
                  child: Text('Register New Account'))
            ],
          ),
        ),
      );
    });
  }
}
