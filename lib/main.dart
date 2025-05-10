import 'package:admin_panel_ak/constants/mycustomscroller.dart';
import 'package:admin_panel_ak/constants/theame.dart';
import 'package:admin_panel_ak/features/auth/screen/login.dart';
import 'package:admin_panel_ak/features/dastbord/dastbord.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:admin_panel_ak/firebase_helper/firebase_options/firebase_options.dart';
import 'package:admin_panel_ak/provider/appProvider.dart';
import 'package:admin_panel_ak/provider/bookingProvider.dart';
import 'package:admin_panel_ak/provider/calender_provider.dart';
import 'package:admin_panel_ak/provider/reviewsProvider.dart';
import 'package:admin_panel_ak/provider/serviceProvider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
        ChangeNotifierProvider(create: (context) => CalenderProvider()),
        ChangeNotifierProvider(create: (context) => Reviewsprovider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SabEmpire Admin',
          theme: themeData,
          scrollBehavior: MyCustomScroller(),
          home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              Dimensions.init(context); // Initialize dimensions
              if (snapshot.hasData) {
                return const HomeDashBord(); // Direct to LoadingHomePage if user is authenticated
              }
              return LogingPage(); // Show LoginScreen if user is not authenticated
            },
          ),
        );
      },
    );
  }
}
