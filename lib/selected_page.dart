import 'package:flutter/foundation.dart';

class SelectedPage extends ChangeNotifier {
  int selectedPage = 0;
  void Function(int)? onChangedPage;

  void selectPage(int page) {
    selectedPage = page;
    notifyListeners();
    onChangedPage?.call(selectedPage);
  }
}