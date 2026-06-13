import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sl_police_traffic_fines/main.dart';

void main() {
  testWidgets('App loads login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TrafficFineApp()));
    expect(find.text('Officer Login'), findsOneWidget);
  });
}
