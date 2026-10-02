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
import 'package:admin_panel_ak/provider/spin_wheel_provider.dart';
import 'package:admin_panel_ak/utility/dimenison.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(
          create: (_) => AppProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalenderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Reviewsprovider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SpinWheelProvider(),
        ),
      ],
      child: ScreenUtilPlusInit(
        designSize: const Size(1440, 900),
        minTextAdapt: true,
        splitScreenMode: true,

        // Better performance.
        // Use context.w(), context.h(), context.r(), context.sp()
        // in widgets when this is false.
        autoRebuild: false,

        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SabEmpire Admin',
            theme: themeData,
            scrollBehavior: MyCustomScroller(),
            home: const AuthGate(),
          );
        },
        child: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return StreamBuilder(
      stream: FirebaseAuthHelper.instance.getAuthChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data != null) {
          return const HomeDashBord();
        }

        return LogingPage();
      },
    );
  }
}