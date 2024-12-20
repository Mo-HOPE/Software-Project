class ProductModel {
  String name;
  String seller;
  String category;
  String description;
  String photo;
  double discount;
  double price;

  ProductModel({
    required this.name,
    required this.seller,
    required this.category,
    required this.description,
    required this.photo,
    required this.discount,
    required this.price,
  }) {
    price = priceAfterDiscount();
  }

  double priceAfterDiscount() {
    return price - ((price * discount) / 100);
  }
}
