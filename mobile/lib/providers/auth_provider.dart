import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../services/api_client.dart';

class AuthState {
  final String? token;
  final String? email;
  final String? role;
  final String? name;
  final bool isLoading;

  const AuthState({
    this.token,
    this.email,
    this.role,
    this.name,
    this.isLoading = false,
  });

  bool get isAuthenticated => token != null;

  AuthState copyWith({
    String? token,
    String? email,
    String? role,
    String? name,
    bool? isLoading,
  }) {
    return AuthState(
      token: token ?? this.token,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api;

  AuthNotifier(this._api) : super(const AuthState()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    if (token != null) {
      state = state.copyWith(token: token);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _api.login(email, password);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Login failed');
      }
      final data = response['data'] as Map<String, dynamic>;
      final token = data['token'] as String;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, token);
      state = AuthState(
        token: token,
        email: data['email'] as String?,
        role: data['role'] as String?,
        name: data['name'] as String?,
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    state = const AuthState();
  }
}

final apiClientProvider = Provider((ref) => ApiClient());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiClientProvider));
});
