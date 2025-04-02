// import 'package:admin_panel_ak/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
// import 'package:admin_panel_ak/routes/route_name.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'package:admin_panel_ak/utility/dimenison.dart';

// class RouteConfig {
//   static GoRouter returnRouter() {
//     return GoRouter(
//       // Define the initial location of the app.
//       initialLocation: RouteNames.initial,
//       routes: [
//         // The initial route checks for authentication.
//         GoRoute(
//           path: RouteNames.initial,
//           name: RouteNames.initial,
//           redirect: (BuildContext context, GoRouterState state) async {
//             try {
//               // Listen to the auth change stream and take the first snapshot.
//               final userStream = FirebaseAuthHelper.instance.getAuthChange;
//               final snapshot = await userStream.first;

//               // Redirect based on authentication status.
//               if (snapshot != null) {
//                 return RouteNames.landingHome;
//               } else {
//                 return RouteNames.landingLogin;
//               }
//             } catch (e) {
//               debugPrint("Error in initial redirect: $e");
//               // In case of error, fallback to the login route.
//               return RouteNames.landingLogin;
//             }
//           },
//         ),
//         // Login route.
//         GoRoute(
//           path: RouteNames.login,
//           name: RouteNames.login,
//           pageBuilder: (BuildContext context, GoRouterState state) {
//             Dimensions.init(
//                 context); // Initialize dimensions for responsiveness.
//             return const MaterialPage(child: LoginScreen());
//           },
//         ),
//         // Landing Home route.
      
      
//         // Signup route.
//         GoRoute(
//           path: RouteNames.singUp,
//           name: RouteNames.singUp,
//           pageBuilder: (BuildContext context, GoRouterState state) {
//             Dimensions.init(context);
//             return const MaterialPage(child: SingupScreen());
//           },
//         ),
//         // Home page route.
//         GoRoute(
//           path: RouteNames.homePage,
//           name: RouteNames.homePage,
//           pageBuilder: (BuildContext context, GoRouterState state) {
//             Dimensions.init(context);
//             return const MaterialPage(child: HomePage());
//           },
//           routes: [
//             // Nested route for the salon list.
//             GoRoute(
//               path: RouteNames.salonList,
//               name: RouteNames.salonList,
//               pageBuilder: (BuildContext context, GoRouterState state) {
//                 Dimensions.init(context);
//                 return const MaterialPage(child: SalonPage());
//               },
//             ),
//             GoRoute(
//               path: RouteNames.salonDashbord,
//               name: RouteNames.salonDashbord,
//               pageBuilder: (BuildContext context, GoRouterState state) {
//                 final adminId = state.pathParameters['adminId']!;
//                 final salonId = state.pathParameters['salonId']!;
//                 Dimensions.init(context);
//                 return MaterialPage(
//                     child: VenderMenuPage(adminId: adminId, salonId: salonId));
//               },
//             ),
//             GoRoute(
//               path: RouteNames.salonSetting,
//               name: RouteNames.salonSetting,
//               pageBuilder: (BuildContext context, GoRouterState state) {
//                 Dimensions.init(context);
//                 return const MaterialPage(child: SalonPage());
//               },
//             ),
//             GoRoute(
//               path: RouteNames.employeeInforPage,
//               name: RouteNames.employeeInforPage,
//               pageBuilder: (BuildContext context, GoRouterState state) {
//                 final employeeId = state.pathParameters['employeeId']!;
//                 Dimensions.init(context);
//                 return MaterialPage(
//                     child: EmployeeInforPage(employeeId: employeeId));
//               },
//             ),
//             GoRoute(
//                 path: RouteNames.userList,
//                 name: RouteNames.userList,
//                 pageBuilder: (BuildContext context, GoRouterState state) {
//                   Dimensions.init(context);
//                   return MaterialPage(child: UserList());
//                 },
//                 routes: [
//                   GoRoute(
//                     path: RouteNames.userMenus,
//                     name: RouteNames.userMenus,
//                     pageBuilder: (BuildContext context, GoRouterState state) {
//                       final userID = state.pathParameters['userID']!;
//                       Dimensions.init(context);
//                       return MaterialPage(
//                           child: UserMenuScreen(
//                         userId: userID,
//                       ));
//                     },
//                   ),
//                 ]),
//           ],
//         ),
//         // Dashboard main page with nested routes.
//         GoRoute(
//           path: RouteNames.dashbord,
//           name: RouteNames.dashbord,
//           pageBuilder: (BuildContext context, GoRouterState state) {
//             Dimensions.init(context);
//             return const MaterialPage(child: DashbordScreen());
//           },
//         ),
//         // GoRoute(
//         //   path: RouteNames.userProfile,
//         //   name: RouteNames.userProfile,
//         //   pageBuilder: (BuildContext context, GoRouterState state) {
//         //     Dimensions.init(context);
//         //     return const MaterialPage(child: DashbordScreen1());
//         //   },
//         // ),
//       ],
//     );
//   }
// }
