import 'package:flutter_test/flutter_test.dart';
import 'package:alive/main.dart';
import 'package:alive/data/repositories/auth_repository.dart';
import 'package:alive/data/repositories/stream_repository.dart';

void main() {
  testWidgets('App splash screen render smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(
        authRepository: HybridAuthRepository(),
        streamRepository: MockStreamRepository(),
      ),
    );

    // Verify that the splash screen loading text is present
    expect(find.text('Live Streaming Network'), findsOneWidget);

    // Pump frames to let the Splash Screen's 2.8s transition timer and animations complete
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
