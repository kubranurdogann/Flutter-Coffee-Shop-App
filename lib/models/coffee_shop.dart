import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_app/iterable_extension.dart';
import 'package:coffee_shop_app/models/coffee.dart';
import 'package:flutter/material.dart';

String generateUniqueId() {
  return FirebaseFirestore.instance.collection('users').doc().id;
}

class CoffeeShop extends ChangeNotifier {
  late List<Coffee> _shop = [
    Coffee(
        id: generateUniqueId(), // Benzersiz ID
        name: 'Long Black',
        price: 70,
        imagePath: "lib/images/coffee1.png",
        quantity: 1,
        ingredients: 'Espresso beans, Long Black with Cold Water'),
    Coffee(
        id: generateUniqueId(),
        name: 'Espresso',
        price: 80,
        imagePath: "lib/images/coffee2.png",
        quantity: 1,
        ingredients: 'Single, Double'),
    Coffee(
        id: generateUniqueId(),
        name: 'Latte',
        price: 100,
        imagePath: "lib/images/coffee3.png",
        quantity: 1,
        ingredients: 'Vanilin, Caramel, Chocolate'),
    Coffee(
        id: generateUniqueId(),
        name: 'Cappucino',
        price: 90,
        imagePath: "lib/images/coffee4.png",
        quantity: 1,
        ingredients: 'Traditional Cappuccino, Iced Cappuccino'),
    Coffee(
        id: generateUniqueId(),
        name: 'Filter Coffee',
        price: 85,
        imagePath: "lib/images/coffee5.png",
        quantity: 1,
        ingredients: 'Drip Coffee, Pour Over (V60, Chemex, Kalita Wave)'),
  ];

  //user cart
  List<Coffee> _userCart = [];

  //get coffee list
  List<Coffee> get coffeeShop => _shop;

  //get user cart
  List<Coffee> get userCart => _userCart;

  // Sepeti ayarlamak için kullanılan fonksiyon
  void setUserCart(List<Coffee> cartItems) {
    _userCart = cartItems;
    notifyListeners(); // Değişikliği dinleyicilere bildir
  }

  void clearCart() {
    userCart.clear();
    notifyListeners(); // Dinleyicilere bildir
  }

//total price
  double get total =>
      _userCart.fold(0, (sum, item) => sum + item.price * item.quantity);

Future<void> fetchCoffeeData(String uid) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    final snapshot = await _firestore.collection('coffees').get();
    _shop.clear(); // Mevcut verileri temizle

    for (var doc in snapshot.docs) {
      Coffee coffee = Coffee.fromMap(doc.data());
      _shop.add(coffee);
    }

    notifyListeners();
  } catch (e) {
    print("Failed to load coffee: $e"); // Hata mesajını yazdır
    throw e; // Hata durumunu fırlat
  }
}


  Future<void> fetchCartFromFirestore(String userId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot cartSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      List<Coffee> cartItems = cartSnapshot.docs.map((doc) {
        return Coffee.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      // Sepeti UI'da göstermek için gerekli işlemleri yapın
    } catch (e) {
      print("Failed to fetch cart: $e");
    }
  }

  void addItemtoCart(Coffee coffee, String userId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore'da bu kahve var mı kontrol et
  final coffeeDoc = await _firestore
      .collection('users')
      .doc(userId)
      .collection('cart')
      .doc(coffee.id)
      .get();

  if (coffeeDoc.exists) {
    // Eğer varsa, Firestore'daki miktarı arttır
    Map<String, dynamic> coffeeData = coffeeDoc.data()!;
    int existingQuantity = coffeeData['quantity'] ?? 1;
    int newQuantity = existingQuantity + coffee.quantity;

    // Firestore'da miktarı güncelle
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(coffee.id)
        .update({'quantity': newQuantity});

    // Yerel sepeti güncelle
    Coffee existingItem = _userCart.firstWhere((item) => item.id == coffee.id);
    existingItem.quantity = newQuantity;
  } else {
    // Eğer yoksa, yeni öğe olarak ekle
    coffee.quantity = coffee.quantity > 0 ? coffee.quantity : 1; // Varsayılan olarak 1
    _userCart.add(coffee);

    // Firestore'da yeni belge oluştur
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(coffee.id)
        .set(coffee.toMap());
  }

  // Dinleyicilere sepetin güncellendiğini bildir
  notifyListeners();
}


Future<void> loadCartFromFirestore(String userId) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore'dan sepet verilerini çek
  final snapshot = await _firestore
      .collection('users')
      .doc(userId)
      .collection('cart')
      .get();

  _userCart.clear(); // Önce mevcut sepeti temizle

  for (var doc in snapshot.docs) {
    Coffee coffee = Coffee.fromMap(doc.data());
    coffee.quantity = doc.data()['quantity'] ?? 1; // Miktarı ayarla
    _userCart.add(coffee);
  }

  notifyListeners();
}


void resetQuantities() {
  for (var coffee in _shop) {
    coffee.quantity = 0; // Miktarı sıfırla
  }
  notifyListeners(); // Değişiklikleri dinleyicilere bildir
}



  //increase item quantity in cart
  void increaseQuantity(Coffee coffee) {
    coffee.quantity++;
    notifyListeners();
  }

  //decrease item quantity in cart
  void decreaseQuantity(Coffee coffee) {
    if (coffee.quantity > 1) {
      coffee.quantity--;
      notifyListeners();
    }
  }

  //remove item from cart
  void removeItemFromCart(Coffee coffee) {
    _userCart.remove(coffee);
    notifyListeners();
  }


}


