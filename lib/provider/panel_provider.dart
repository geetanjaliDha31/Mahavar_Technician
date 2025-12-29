import 'package:flutter/cupertino.dart';

class PanelProvider extends ChangeNotifier {
  Widget widget;
  double height;

  PanelProvider({this.height = 0, this.widget = const SizedBox.shrink()});

  bool _isPanelOpen = false;

  bool get isPanelOpen => _isPanelOpen;

  void openPanel(Widget panelWidget, double panelHeight) async {
    // Open the panel
    widget = panelWidget;
    height = panelHeight;
    _isPanelOpen = true;
    notifyListeners();
  }

  void closePanel() async {
    // Close the panel
    _isPanelOpen = false;
    notifyListeners();
  }
  // void openPanel(Widget data, double h) async {
  //   widget = data;
  //   height = h;
  //   notifyListeners();
  // }
}
