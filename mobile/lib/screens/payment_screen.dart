import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../providers/fine_provider.dart';
import '../providers/payment_provider.dart';

class PaymentScreen extends HookConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardHolderController = useTextEditingController();
    final cardNumberController = useTextEditingController();
    final paymentState = ref.watch(paymentProvider);
    final fine = ref.watch(fineProvider).fine;

    if (fine == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppConstants.appTitle)),
        body: const Center(child: Text('No fine data.')),
      );
    }

    Future<void> handlePayment() async {
      if (cardHolderController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter card holder name')),
        );
        return;
      }

      final success = await ref.read(paymentProvider.notifier).processPayment(
            referenceNo: fine['referenceNo'] as String,
            categoryId: fine['categoryId'] as String,
            cardHolderName: cardHolderController.text.trim(),
          );

      if (!context.mounted) return;

      if (success) {
        context.go('/success');
      } else {
        final error = ref.read(paymentProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Payment failed')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Payment — ${fine['referenceNo']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Amount: LKR ${fine['amount']}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(
              controller: cardHolderController,
              decoration: const InputDecoration(
                labelText: 'Card Holder Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: paymentState.isLoading ? null : handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: paymentState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm Payment', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go('/fine-details'),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
