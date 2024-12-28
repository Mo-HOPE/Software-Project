class CustomerModel {
  String name;
  String email;
  String password;
  String address;
  String phone;
  List<int> cartProducts;
  List<int> whishListProducts;

  CustomerModel({
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
    required this.cartProducts,
    required this.whishListProducts,
  });
}
