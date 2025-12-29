import 'package:flutter/material.dart';

class SlidingUpPanelProvider extends ChangeNotifier {
  int index = 0;

  SlidingUpPanelProvider({this.index = 0});
  
  void changeindex(int idx) async {
    index = idx;
    notifyListeners();
  }
}
