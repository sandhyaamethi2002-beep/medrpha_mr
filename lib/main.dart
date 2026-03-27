import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medrpha_new/screens/place_order_screen.dart';
import 'package:provider/provider.dart';
import 'AppManager/ViewModel/AddtocartVM/DeleteCartById_vm.dart';
import 'AppManager/ViewModel/AddtocartVM/placeOrder_vm.dart';
import 'AppManager/ViewModel/CategoryVM/getByCategoryId_vm.dart';
import 'AppManager/ViewModel/LoginVM/verify_login_otp_vm.dart';
import 'Provider/cart_provider.dart';
import 'Provider/order_provider.dart';
import 'Provider/saved_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  HttpOverrides.global = MyHttpOverrides();

  Get.put(VerifyLoginOtpVM());


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
        ChangeNotifierProvider(create: (_) => GetByCategoryVM()),
        ChangeNotifierProvider(create: (_) => PlaceOrderVM()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => DeleteCartByIdVM()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medrpha MR',
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/confirmOrder', page: () => PlaceOrderScreen(
          firmId: Get.arguments['firmId'],
          userId: Get.arguments['userId'],
          roleId: Get.arguments['roleId'] ,
          userTypeId: Get.arguments['userTypeId'],
        ),
        ),
      ],
    );
  }
}