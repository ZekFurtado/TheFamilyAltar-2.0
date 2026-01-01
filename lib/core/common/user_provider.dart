import 'package:flutter/cupertino.dart';
// import 'package:thefamilyaltar/src/authentication/domain/entities/user.dart';

class UserProvider extends ChangeNotifier {
  // LocalUser? _user;
  dynamic _user;

  // LocalUser? get user => _user;
  dynamic get user => _user;

  // void initUser(LocalUser? user) {
  void initUser(dynamic user) {
    if (_user != user) _user = user;
  }

  // set user(LocalUser? user) {
  set user(dynamic user) {
    if (_user != user) {
      _user = user;
    }
    // Future.delayed(Duration.zero, notifyListeners);
  }
}
