import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../providers/fine_provider.dart';
import '../providers/payment_provider.dart';

class SuccessScreen extends ConsumerWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(paymentProvider).receipt;
    final formatter = NumberFormat('#,##0.00');

    if (receipt == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppConstants.appTitle)),
        body: const Center(child: Text('No receipt data.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 72),
            const SizedBox(height: 16),
            const Text('Payment Successful', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _receiptRow('Reference', receipt['referenceNo']),
                    _receiptRow('Amount Paid', 'LKR ${formatter.format(receipt['amountPaid'])}'),
                    _receiptRow('Transaction Ref', receipt['transactionRef']),
                    _receiptRow('Paid At', DateTime.parse(receipt['paidAt']).toLocal().toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                'Payment confirmed. Officer notified via SMS.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ref.read(fineProvider.notifier).clear();
                ref.read(paymentProvider.notifier).clear();
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('New Payment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(child: Text('$value', style: const TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
