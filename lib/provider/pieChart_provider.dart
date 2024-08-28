import 'package:flutter/material.dart';

class PiechartProvider with ChangeNotifier {
  bool _isTicketRaised = false;
  bool get isTicketRaised => _isTicketRaised;

  void reloadWidget(bool value) {
    _isTicketRaised = value;
    notifyListeners();
  }
  
}
