import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: AppConstants.kBaseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> lookupFine(String referenceNo) async {
    final response = await dio.get('/fines/$referenceNo');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCategories() async {
    final response = await dio.get('/categories');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> issueFine(Map<String, dynamic> payload) async {
    final response = await dio.post('/fines', data: payload);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> processPayment(Map<String, dynamic> payload) async {
    final response = await dio.post('/payments', data: payload);
    return response.data as Map<String, dynamic>;
  }
}
