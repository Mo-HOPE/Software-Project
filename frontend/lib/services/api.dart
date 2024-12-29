import 'package:dio/dio.dart';
import 'package:frontend/models/customer_model.dart';
import 'package:frontend/models/product_model.dart'; // Adjust the import based on your project structure

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://outfitonv2-hqdnefb7hfdtg2gm.canadacentral-01.azurewebsites.net/api/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<CustomerModel> getCustomerInfo(String email) async {
    try {
      final response = await _dio.get('get-customer-info/$email/');
      return CustomerModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data['error'] ?? e.message}');
      } else {
        throw Exception('Failed to connect to the server: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Response> createCustomer({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        'create-customer/',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<String> checkCustomerExists({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        'login-customer/',
        data: {
          'email': email,
          'password': "b",
        },
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['error'] ?? 'An error occurred';
      } else {
        return 'Failed to connect to the server: ${e.message}';
      }
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  Future<Response> loginCustomer({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'login-customer/',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> updateCustomerInfo({
    required String email,
    String? name,
    List<int>? wishlistProducts,
    List<int>? cartProducts,
  }) async {
    try {
      final response = await _dio.put(
        'update-customer-info/',
        data: {
          'email': email,
          'name': name,
          'wishlist_products': wishlistProducts,
          'cart_products': cartProducts,
        },
      );

      if (response.statusCode == 200) {
        print('Customer info updated successfully');
      } else {
        throw Exception('Failed to update customer info: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data['error'] ?? e.message}');
      } else {
        throw Exception('Failed to connect to the server: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Response> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        'reset-customer-password/',
        data: {
          'email': email,
          'new_password': newPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<Response> sendOtp({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        'send-otp/',
        data: {
          'email': email,
        },
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProducts(String category) async {
    try {
      final response = await _dio.get('get-products/$category/');
      List<dynamic> data = response.data;

      return data.map((product) => ProductModel.fromMap(product)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final response = await _dio.get('search-products/$keyword/');
      List<dynamic> data = response.data;

      return data.map((product) => ProductModel.fromMap(product)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ProductModel> getProductInfo(int id) async {
    try {
      final response = await _dio.get('get-product-info/$id/');
      return ProductModel.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response?.data['error'] ?? e.message}');
      } else {
        throw Exception('Failed to connect to the server: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
