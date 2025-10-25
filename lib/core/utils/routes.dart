import 'package:thefamilyaltar/src/authentication/presentation/pages/login.dart';
import 'package:thefamilyaltar/src/authentication/presentation/pages/login_new.dart';

class Routes {
  static var routes = {
    '/login': (context) => const LoginScreen(),
    '/loginNew': (context) => const LoginNew(),
    // '/home': (context) => const HomeScreen(),
  };
}
