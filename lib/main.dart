import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_foot_client/controller/home_controller.dart';
import 'package:new_foot_client/controller/login_controller.dart';
import 'package:new_foot_client/controller/purchase_controller.dart';
import 'package:new_foot_client/firebase_options.dart';
import 'package:new_foot_client/pages/login_page.dart';
import 'package:new_foot_client/pages/register_page.dart';

// Platform  Firebase App Id
// android   1:666207197593:android:3040957362ba7ea97ddb08

//Model generator
// flutter pub run build_runner build --delete-conflicting-outputs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PurchaseController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'New foot Client App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
