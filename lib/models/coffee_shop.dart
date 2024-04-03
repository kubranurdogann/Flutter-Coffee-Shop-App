import 'package:coffee_shop_app/models/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeShop extends ChangeNotifier {
  final List<Coffee> _shop = [
    Coffee(
        name: 'Long Black',
        price: 70,
        imagePath: "lib/images/coffee1.png",
        quantity: 1),
    Coffee(
        name: 'Latte',
        price: 80,
        imagePath: "lib/images/coffee2.png",
        quantity: 1),
    Coffee(
        name: 'Espresso',
        price: 100,
        imagePath: "lib/images/coffee3.png",
        quantity: 1),
    Coffee(
        name: 'Cappucino',
        price: 90,
        imagePath: "lib/images/coffee4.png",
        quantity: 1),
    Coffee(
        name: 'Filter Coffee',
        price: 85,
        imagePath: "lib/images/coffee5.png",
        quantity: 1),
  ];

  //user cart
  List<Coffee> _userCart = [];

  //get coffee list
  List<Coffee> get coffeeShop => _shop;

  //get user cart
  List<Coffee> get userCart => _userCart;

  //total price
  double get total => userCart.fold(0, (sum, item) => sum + item.price);

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
