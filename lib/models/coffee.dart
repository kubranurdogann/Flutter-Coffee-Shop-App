class Coffee {
  String id; // Yeni ID alanı
  String name;
  int price;
  String imagePath;
  int quantity;
  String ingredients;

  Coffee({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.quantity,
    required this.ingredients,
  });

  // Firestore'dan veri dönüşümü
  factory Coffee.fromMap(Map<String, dynamic> map) {
    return Coffee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      imagePath: map['imagePath'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      ingredients: map['ingredients'] ?? '',
    );
  }

  // Veriyi Firestore'a kaydetmek için dönüşüm
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'quantity': quantity,
      'ingredients': ingredients,
    };
  }
}
