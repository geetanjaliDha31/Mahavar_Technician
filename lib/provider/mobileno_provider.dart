import 'package:flutter/cupertino.dart';

class MobileNo extends ChangeNotifier {
  String _mobileNumber = '';

  String get mobileNumber => _mobileNumber;

  void setMobileNumber(String newMobileNumber) {
    _mobileNumber = newMobileNumber;
    notifyListeners();
  }
}
