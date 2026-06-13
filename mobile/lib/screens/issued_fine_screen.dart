import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../providers/fine_provider.dart';

class IssuedFineScreen extends ConsumerWidget {
  const IssuedFineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fine = ref.watch(fineProvider).fine;

    if (fine == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppConstants.appTitle)),
        body: const Center(child: Text('No issued fine data.')),
      );
    }

    final amount = fine['amount'];
    final formatter = NumberFormat('#,##0.00');
    final qrCodeDataUrl = fine['qrCodeDataUrl'] as String?;
    final qrBytes = _decodeQrDataUrl(qrCodeDataUrl);

    return Scaffold(
      appBar: AppBar(title: const Text('Fine Issued')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_2, size: 44, color: AppConstants.primaryColor),
                      const SizedBox(height: 12),
                      Text(
                        fine['referenceNo'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'LKR ${formatter.format(amount is num ? amount : 0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      if (qrBytes != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.white,
                          child: Image.memory(qrBytes, width: 240, height: 240),
                        )
                      else
                        const Text('QR code is not available for this fine.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _detailRow('Category ID', fine['categoryId']),
              _detailRow('Payment URL', fine['paymentUrl']),
              _detailRow('Driver', fine['driverName']),
              _detailRow('Vehicle', fine['vehicleNo']),
              _detailRow('Category', fine['categoryDescription']),
              _detailRow('District', fine['district']),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Issue Another Fine'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.go('/fine-details'),
                child: const Text('View Fine Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Uint8List? _decodeQrDataUrl(String? dataUrl) {
    if (dataUrl == null || !dataUrl.contains(',')) return null;
    return base64Decode(dataUrl.split(',').last);
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            '${value ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
