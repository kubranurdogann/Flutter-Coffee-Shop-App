class Coffee {
  String name;
  String price;
  String imagePath;

  Coffee({
    required this.name,
    required this.price,
    required this.imagePath,
  });

//veri dönüşümü
  factory Coffee.fromMap(Map<dynamic, dynamic> map) {
    return Coffee(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }
}
