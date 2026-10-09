import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:printer_testing/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: LocalNetworkTransferApp(),
      ),
    );

    // Verify title is rendered
    expect(find.text('Wi-Fi / Hotspot Data & Printer'), findsOneWidget);
  });
}
