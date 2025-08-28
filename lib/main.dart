import 'package:auroo/context/Product_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/Welcome_Screen.dart';
import 'screens/AddProduct_Screen.dart';
import 'screens/Cart_Screen.dart';
import 'screens/ShopNow_Screen.dart';
import 'screens/Login_Screen.dart';
import 'screens/CheckOut_Screen.dart';
import 'screens/Payment_Screen.dart';
import 'screens/COD_Payment_Screen.dart';
import 'screens/Card_Payment_Screen.dart';
import 'screens/Tracking_Details_Screen.dart';

import 'navigation/bottom_nav_bar.dart';

import 'profile/about_us.dart';
import 'profile/chat_support.dart';
import 'profile/privacy.dart';
import 'profile/terms.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this for proper initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your providers here
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'MarketPlace',
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Helvetica',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),

          '/home': (context) => const BottomNavBar(),
          '/about_us': (context) => const AboutUsScreen(),
          '/chat_support': (context) => const ChatSupportScreen(),
          '/privacy': (context) => const PrivacyPolicyScreen(),
          '/terms': (context) => const TermsOfUseScreen(),
          '/cart': (context) => const CartScreen(),
          '/shop_now': (context) => const ShopNowScreen(),
          '/add_product': (context) => const AddProductScreen(),
          '/login': (context) => const LoginScreen(),
          '/checkout': (context) => const CheckOutScreen(),
          '/payment': (context) => const PaymentScreen(),
          '/cod_payment': (context) => const CODPaymentScreen(),
          '/card_payment': (context) => const CardPaymentScreen(),
          '/tracking_details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as CartItem;
            return TrackingDetailsScreen(order: args);
          },
        },
      ),
    );
  }
}
