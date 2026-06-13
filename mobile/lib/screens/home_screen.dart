import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../providers/fine_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appTitle),
          actions: [
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: 'Issue Fine'),
              Tab(icon: Icon(Icons.search), text: 'Look Up'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _IssueFineTab(),
            _LookupFineTab(),
          ],
        ),
      ),
    );
  }
}

class _IssueFineTab extends HookConsumerWidget {
  const _IssueFineTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiClientProvider);
    final categoriesFuture = useMemoized(api.getCategories);
    final categoriesSnapshot = useFuture(categoriesFuture);
    final driverController = useTextEditingController();
    final vehicleController = useTextEditingController();
    final districtController = useTextEditingController();
    final selectedCategoryId = useState<String?>(null);
    final fineState = ref.watch(fineProvider);

    final categories = _extractCategories(categoriesSnapshot.data);

    Future<void> handleIssueFine() async {
      final categoryId = selectedCategoryId.value;
      if (categoryId == null ||
          driverController.text.trim().isEmpty ||
          vehicleController.text.trim().isEmpty ||
          districtController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all fine details')),
        );
        return;
      }

      ref.read(fineProvider.notifier).clear();
      await ref.read(fineProvider.notifier).issueFine(
            categoryId: categoryId,
            driverName: driverController.text.trim(),
            vehicleNo: vehicleController.text.trim(),
            district: districtController.text.trim(),
          );

      final state = ref.read(fineProvider);
      if (state.error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
      } else if (state.fine != null && context.mounted) {
        context.go('/issued-fine');
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Issue Fine', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            if (categoriesSnapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator())
            else if (categoriesSnapshot.hasError)
              const Text('Could not load fine categories.', style: TextStyle(color: Colors.red))
            else
              DropdownButtonFormField<String>(
                value: selectedCategoryId.value,
                decoration: const InputDecoration(
                  labelText: 'Fine Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.rule),
                ),
                items: categories.map((category) {
                  final amount = category['amount'];
                  return DropdownMenuItem<String>(
                    value: category['id'] as String,
                    child: Text(
                      '${category['categoryCode']} - ${category['description']} (LKR $amount)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) => selectedCategoryId.value = value,
              ),
            const SizedBox(height: 16),
            TextField(
              controller: driverController,
              decoration: const InputDecoration(
                labelText: 'Driver Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: vehicleController,
              decoration: const InputDecoration(
                labelText: 'Vehicle Number',
                hintText: 'e.g. ABC-1234',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_car),
              ),
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: districtController,
              decoration: const InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: fineState.isLoading ? null : handleIssueFine,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: fineState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.qr_code_2),
              label: Text(fineState.isLoading ? 'Issuing...' : 'Issue Fine and Show QR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LookupFineTab extends HookConsumerWidget {
  const _LookupFineTab();

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

    return SafeArea(
      child: SingleChildScrollView(
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
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                hintText: 'UUID from fine slip',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: fineState.isLoading ? null : handleLookup,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: fineState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.search),
              label: Text(fineState.isLoading ? 'Looking up...' : 'Look Up Fine'),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> _extractCategories(Map<String, dynamic>? response) {
  final data = response?['data'];
  if (data is! List) return const [];
  return data.whereType<Map<String, dynamic>>().toList();
}
