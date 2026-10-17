import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn/data/content.dart';
import 'package:learn/data/progress_manager.dart';
import 'package:learn/main.dart';
import 'package:learn/ui/flashcard_screen.dart';
import 'package:learn/ui/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App renders home screen smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final progressManager = await ProgressManager.init();
    await tester.pumpWidget(MyApp(progressManager: progressManager));

    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets('iPad tablet size renders HomeScreen and navigates without overflow', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final progressManager = await ProgressManager.init();

    // Standard iPad portrait (768 x 1024)
    tester.view.physicalSize = const Size(768, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(MyApp(progressManager: progressManager));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MyApp), findsOneWidget);

    // Test FlashcardScreen at iPad size
    final category = categoriesData.first;
    await tester.pumpWidget(
      MaterialApp(
        home: FlashcardScreen(
          category: category,
          progressManager: progressManager,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(category.name), findsOneWidget);

    // Try tapping Next button on iPad view through multiple cards
    final nextButtonFinder = find.byIcon(Icons.chevron_right_rounded);
    expect(nextButtonFinder, findsOneWidget);
    expect(find.text('1 / 6'), findsOneWidget);

    // Tap to 2 / 6
    await tester.tap(nextButtonFinder);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('2 / 6'), findsOneWidget);

    // Advance to 6 / 6
    for (int i = 2; i < 6; i++) {
      await tester.tap(nextButtonFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));
    }
    expect(find.text('6 / 6'), findsOneWidget);

    // Tapping next on last card transitions directly to quiz
    await tester.tap(nextButtonFinder);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(QuizScreen), findsOneWidget);
  });

  testWidgets('iPad Pro large tablet size renders cleanly without overflow', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final progressManager = await ProgressManager.init();

    // iPad Pro 12.9" portrait (1024 x 1366)
    tester.view.physicalSize = const Size(1024, 1366);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(MyApp(progressManager: progressManager));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MyApp), findsOneWidget);

    final category = categoriesData.first;
    await tester.pumpWidget(
      MaterialApp(
        home: FlashcardScreen(
          category: category,
          progressManager: progressManager,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(category.name), findsOneWidget);

    final vocabList = vocabularyData[category.id] ?? [];
    await tester.pumpWidget(
      MaterialApp(
        home: QuizScreen(
          category: category,
          vocabList: vocabList,
          progressManager: progressManager,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(category.name), findsOneWidget);
  });
}

