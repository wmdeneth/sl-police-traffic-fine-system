import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import 'screens/login_screen.dart';
import 'screens/startup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/fine_details_screen.dart';
import 'screens/issued_fine_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/success_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TrafficFineApp()));
}

final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/startup',
    routes: [
      GoRoute(path: '/startup', builder: (context, state) => const StartupScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/fine-details', builder: (context, state) => const FineDetailsScreen()),
      GoRoute(path: '/issued-fine', builder: (context, state) => const IssuedFineScreen()),
      GoRoute(path: '/payment', builder: (context, state) => const PaymentScreen()),
      GoRoute(path: '/success', builder: (context, state) => const SuccessScreen()),
    ],
  );
});

class TrafficFineApp extends ConsumerWidget {
  const TrafficFineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);

    return MaterialApp.router(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          primary: AppConstants.primaryColor,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      routerConfig: router,
    );
  }
}
