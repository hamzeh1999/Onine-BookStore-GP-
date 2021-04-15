import 'package:flutter/foundation.dart';
import 'package:gradproject/Config/config.dart';

class CartItemCounter extends ChangeNotifier{
  int _counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;
  int get count => _counter;
}