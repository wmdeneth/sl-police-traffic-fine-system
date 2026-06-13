import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import 'auth_provider.dart';

class FineState {
  final Map<String, dynamic>? fine;
  final bool isLoading;
  final String? error;

  const FineState({this.fine, this.isLoading = false, this.error});

  FineState copyWith({
    Map<String, dynamic>? fine,
    bool? isLoading,
    String? error,
  }) {
    return FineState(
      fine: fine ?? this.fine,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FineNotifier extends StateNotifier<FineState> {
  final ApiClient _api;

  FineNotifier(this._api) : super(const FineState());

  Future<void> lookupFine(String referenceNo, String categoryId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.lookupFine(referenceNo);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Fine not found');
      }
      final fine = response['data'] as Map<String, dynamic>;
      if (fine['categoryId'] != categoryId) {
        throw Exception('Category ID does not match this fine reference.');
      }
      state = FineState(fine: fine);
    } catch (e) {
      state = FineState(error: e.toString().replaceFirst('Exception: ', ''));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> issueFine({
    required String categoryId,
    required String driverName,
    required String vehicleNo,
    required String district,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.issueFine({
        'categoryId': categoryId,
        'driverName': driverName,
        'vehicleNo': vehicleNo,
        'district': district,
      });
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Fine could not be issued');
      }
      state = FineState(fine: response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = FineState(error: e.toString().replaceFirst('Exception: ', ''));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clear() {
    state = const FineState();
  }
}

final fineProvider = StateNotifierProvider<FineNotifier, FineState>((ref) {
  return FineNotifier(ref.watch(apiClientProvider));
});
