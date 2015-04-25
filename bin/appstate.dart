library appstate;

import 'dart:math';

class AppState {
  int balance;
  int fullBalance;
  int numAddresses;
  AppState() {
    balance = pow(10, 24);
    fullBalance = pow(10, 24);
    numAddresses = 0;
  }
}
