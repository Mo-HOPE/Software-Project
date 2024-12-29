import 'package:dio/dio.dart';
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

  // New getProducts function
  Future<List<ProductModel>> getProducts(String category) async {
    try {
      final response = await _dio.get('get-products/$category/');
      List<dynamic> data = response.data;

      // Map API response to a list of ProductModel instances
      return data.map((product) => ProductModel.fromMap(product)).toList();
    } on DioException catch (e) {
      // Handle specific Dio errors here if needed
      throw Exception('Failed to fetch products: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
