import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../providers/fine_provider.dart';

class FineDetailsScreen extends ConsumerWidget {
  const FineDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fine = ref.watch(fineProvider).fine;

    if (fine == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppConstants.appTitle)),
        body: const Center(child: Text('No fine data. Please look up again.')),
      );
    }

    final isPaid = fine['status'] == 'PAID';
    final amount = fine['amount'];
    final formatter = NumberFormat('#,##0.00');

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fine['referenceNo'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPaid ? Colors.green.shade100 : Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            fine['status'] ?? '',
                            style: TextStyle(
                              color: isPaid ? Colors.green.shade800 : Colors.amber.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _detailRow('Driver', fine['driverName']),
                    _detailRow('Vehicle', fine['vehicleNo']),
                    _detailRow('Category', fine['categoryDescription']),
                    _detailRow('Amount', 'LKR ${formatter.format(amount is num ? amount : 0)}'),
                    _detailRow('District', fine['district']),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isPaid ? null : () => context.go('/payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(isPaid ? 'Already Paid' : 'Pay Now', style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
