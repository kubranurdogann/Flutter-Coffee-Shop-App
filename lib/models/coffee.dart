class Coffee {
  String name;
  int price;
  String imagePath;
  int quantity;

  Coffee({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.quantity,
  });

//veri dönüşümü
  factory Coffee.fromMap(Map<dynamic, dynamic> map) {
    return Coffee(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      imagePath: map['imagePath'] ?? '',
      quantity: map['quantity'] ?? '',
    );
  }
}
