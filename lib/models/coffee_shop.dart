import 'package:coffee_shop_app/models/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeShop extends ChangeNotifier {
  final List<Coffee> _shop = [
    Coffee(
        name: 'Long Black', price: "4.10", imagePath: "lib/images/coffee1.png"),
    Coffee(name: 'Latte', price: "4.50", imagePath: "lib/images/coffee2.png"),
    Coffee(
        name: 'Espresso', price: "4.20", imagePath: "lib/images/coffee3.png"),
    Coffee(
        name: 'Cappucino', price: "4.30", imagePath: "lib/images/coffee4.png"),
    Coffee(
        name: 'Filter Coffee',
        price: "4.40",
        imagePath: "lib/images/coffee5.png"),
  ];

  //user cart
  final List<Coffee> _userCart = [];

  //get coffee list
  List<Coffee> get coffeeShop => _shop;

  //get user cart
  List<Coffee> get userCart => _userCart;

  //add item to cart
  void addItemtoCart(Coffee coffee) {
    _userCart.add(coffee);
    notifyListeners();
  }

  //remove item from cart
  void removeItemFromCart(Coffee coffee) {
    _userCart.remove(coffee);
    notifyListeners();
  }
}
