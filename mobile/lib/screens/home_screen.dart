import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../providers/fine_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referenceController = useTextEditingController();
    final categoryController = useTextEditingController();
    final fineState = ref.watch(fineProvider);

    Future<void> handleLookup() async {
      ref.read(fineProvider.notifier).clear();
      await ref.read(fineProvider.notifier).lookupFine(
            referenceController.text.trim(),
            categoryController.text.trim(),
          );
      final state = ref.read(fineProvider);
      if (state.error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
      } else if (state.fine != null && context.mounted) {
        context.go('/fine-details');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Look Up Fine', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: referenceController,
              decoration: const InputDecoration(
                labelText: 'Fine Reference No',
                hintText: 'e.g. TF-ABC123',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                hintText: 'UUID from fine slip',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: fineState.isLoading ? null : handleLookup,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: fineState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Look Up Fine', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
