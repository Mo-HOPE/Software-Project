class ProductModel {
  int id;
  String name;
  String seller;
  String category;
  String description;
  String photo;
  double discount;
  double price;
  int stockQuantity;
  List<String> keywords;
  List<String> sizesList;

  ProductModel({
    required this.id,
    required this.name,
    required this.seller,
    required this.category,
    required this.description,
    required this.photo,
    required this.discount,
    required this.price,
    required this.stockQuantity,
    required this.keywords,
    required this.sizesList,
  });

  double get priceAfterDiscount {
    double discountedPrice = price - ((price * discount) / 100);
    return double.parse(discountedPrice.toStringAsFixed(2));
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      seller: map['seller'],
      category: map['category'],
      description: map['description'],
      photo: map['photo'],
      discount: map['discount']?.toDouble() ?? 0.0,
      price: map['price']?.toDouble() ?? 0.0,
      stockQuantity: map['stock_quantity'] ?? 0,
      keywords: List<String>.from(map['keywords'] ?? []),
      sizesList: List<String>.from(map['sizes_list'] ?? []),
    );
  }
}
