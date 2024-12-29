class CustomerModel {
  final int id;
  final String name;
  final String email;
  final List<int> wishlistProducts;
  final List<int> cartProducts;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.wishlistProducts,
    required this.cartProducts,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      wishlistProducts: List<int>.from(map['wishlist_products']),
      cartProducts: List<int>.from(map['cart_products']),
    );
  }
}
