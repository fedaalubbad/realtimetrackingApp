// // lib/core/router.dart
// import 'package:flutter/material.dart';
//
// import '../presentation/auth/login_page.dart';
// import '../presentation/auth/register_page.dart';
// import '../presentation/home/home_page.dart';
// import '../presentation/splash/splash_page.dart';
//
// class AppRouter {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => const SplashPage(isLoggedIn: isLoggedIn));
//       case '/login':
//         return MaterialPageRoute(builder: (_) => const LoginPage());
//       case '/register':
//         return MaterialPageRoute(builder: (_) => const RegisterPage());
//       case '/home':
//         return MaterialPageRoute(builder: (_) => const HomePage());
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(
//               child: Text('لا يوجد صفحة بهذا الاسم: ${settings.name}'),
//             ),
//           ),
//         );
//     }
//   }
//
//   // اختياري: تسهيل التنقلات
//   static void navigateTo(BuildContext context, String routeName) {
//     Navigator.pushNamed(context, routeName);
//   }
//
//   static void navigateReplacement(BuildContext context, String routeName) {
//     Navigator.pushReplacementNamed(context, routeName);
//   }
//
//   static void navigateAndRemoveAll(BuildContext context, String routeName) {
//     Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
//   }
// }
