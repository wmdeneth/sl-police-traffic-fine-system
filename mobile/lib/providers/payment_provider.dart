import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import 'auth_provider.dart';

class PaymentState {
  final Map<String, dynamic>? receipt;
  final bool isLoading;
  final String? error;

  const PaymentState({this.receipt, this.isLoading = false, this.error});

  PaymentState copyWith({
    Map<String, dynamic>? receipt,
    bool? isLoading,
    String? error,
  }) {
    return PaymentState(
      receipt: receipt ?? this.receipt,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final ApiClient _api;

  PaymentNotifier(this._api) : super(const PaymentState());

  Future<bool> processPayment({
    required String referenceNo,
    required String categoryId,
    required String cardHolderName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.processPayment({
        'referenceNo': referenceNo,
        'categoryId': categoryId,
        'paymentMethod': 'CARD',
        'channel': 'APP',
        'cardHolderName': cardHolderName,
      });
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Payment failed');
      }
      state = PaymentState(receipt: response['data'] as Map<String, dynamic>);
      return true;
    } catch (e) {
      state = PaymentState(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clear() {
    state = const PaymentState();
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref.watch(apiClientProvider));
});
