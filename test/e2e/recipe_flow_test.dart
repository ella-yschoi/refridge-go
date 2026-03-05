import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refridge_go/main.dart';
import 'package:refridge_go/models/recipe.dart';
import 'package:refridge_go/services/openai_service.dart';
import 'package:refridge_go/services/storage_service.dart';

/// Mock API response for recipe generation
String _mockApiResponse(String recipeName) {
  return jsonEncode({
    'choices': [
      {
        'message': {
          'content': jsonEncode({
            'menu': recipeName,
            'description': 'A delicious $recipeName',
            'steps': [
              'Prepare ingredients',
              'Cook everything together',
              'Serve hot',
            ],
            'cookingTime': 25,
            'servings': 2,
            'difficulty': 'Easy',
            'ingredients': ['200g chicken', '1 onion', '2 tbsp soy sauce'],
            'tools': ['Frying pan'],
          }),
        }
      }
    ],
  });
}

/// Scroll to a widget and tap it
Future<void> findAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle();
}

/// Find the FilledButton ancestor of a text widget
/// (FilledButton.icon creates _FilledButtonWithIcon which doesn't match find.byType)
Finder findFilledButton(String text) {
  return find.ancestor(
    of: find.text(text),
    matching: find.byWidgetPredicate((w) => w is FilledButton),
  );
}

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    dotenv.testLoad(fileInput: 'OPENAI_API_KEY=test-key-for-e2e');
    SharedPreferences.setMockInitialValues({});

    OpenAIService().httpClient = MockClient((request) async {
      return http.Response(_mockApiResponse('Chicken Stir Fry'), 200);
    });
  });

  tearDown(() {
    OpenAIService().httpClient = null;
  });

  group('E2E: Recipe generation flow', () {
    testWidgets(
      'Full flow: select ingredients -> generate recipe -> view result -> check history',
      (WidgetTester tester) async {
        // 1. Launch the app
        await tester.pumpWidget(const RefridgeGoApp());
        await tester.pumpAndSettle();

        // 2. Verify home screen
        expect(find.text("What's in your fridge?"), findsOneWidget);

        // 3. Select ingredient
        await findAndTap(tester, find.text('Garlic'));

        // 4. Select cooking tool
        await findAndTap(tester, find.text('Frying pan'));

        // 5. Select difficulty
        await findAndTap(tester, find.text('Easy'));

        // 6. Tap Generate Recipe
        await findAndTap(tester, find.text('Generate Recipe'));
        await tester.pumpAndSettle();

        // 7. Verify recipe result screen
        expect(find.text('Chicken Stir Fry'), findsOneWidget);
        expect(find.text('A delicious Chicken Stir Fry'), findsOneWidget);

        // 8. Verify instructions
        await tester.ensureVisible(find.text('Serve hot'));
        await tester.pumpAndSettle();
        expect(find.text('Prepare ingredients'), findsOneWidget);
        expect(find.text('Cook everything together'), findsOneWidget);
        expect(find.text('Serve hot'), findsOneWidget);

        // 9. Verify auto-save (bookmark icon)
        expect(find.byIcon(Icons.bookmark), findsOneWidget);

        // 10. Go back to home screen
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // 11. Navigate to History tab
        await tester.tap(find.text('Recipes'));
        await tester.pumpAndSettle();

        // 12. Verify saved recipe in history
        expect(find.text('Chicken Stir Fry'), findsOneWidget);

        // 13. View from history
        await tester.tap(find.text('Chicken Stir Fry'));
        await tester.pumpAndSettle();
        expect(find.text('Chicken Stir Fry'), findsWidgets);
      },
    );

    testWidgets(
      'Generate button is disabled until all selections are made',
      (WidgetTester tester) async {
        await tester.pumpWidget(const RefridgeGoApp());
        await tester.pumpAndSettle();

        // Find the button using predicate (handles FilledButton.icon)
        final buttonFinder = findFilledButton('Generate Recipe');

        // Initially disabled
        await tester.ensureVisible(buttonFinder);
        await tester.pumpAndSettle();
        expect(
          tester.widget<FilledButton>(buttonFinder.first).onPressed,
          isNull,
        );

        // Select ingredient — still disabled
        await findAndTap(tester, find.text('Garlic'));
        await tester.ensureVisible(buttonFinder);
        await tester.pumpAndSettle();
        expect(
          tester.widget<FilledButton>(buttonFinder.first).onPressed,
          isNull,
        );

        // Select tool — still disabled
        await findAndTap(tester, find.text('Pot'));
        await tester.ensureVisible(buttonFinder);
        await tester.pumpAndSettle();
        expect(
          tester.widget<FilledButton>(buttonFinder.first).onPressed,
          isNull,
        );

        // Select difficulty — now enabled
        await findAndTap(tester, find.text('Medium'));
        await tester.ensureVisible(buttonFinder);
        await tester.pumpAndSettle();
        expect(
          tester.widget<FilledButton>(buttonFinder.first).onPressed,
          isNotNull,
        );
      },
    );

    testWidgets(
      'History screen shows empty state when no recipes saved',
      (WidgetTester tester) async {
        await tester.pumpWidget(const RefridgeGoApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Recipes'));
        await tester.pumpAndSettle();

        expect(find.text('No saved recipes yet'), findsOneWidget);
        expect(
          find.text('Generate and save recipes to see them here'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'History clear all removes saved recipes',
      (WidgetTester tester) async {
        final storage = StorageService();
        await storage.saveRecipeToHistory(
          Recipe(
            menu: 'Old Recipe',
            description: 'An old recipe',
            steps: ['Step 1'],
          ),
        );

        await tester.pumpWidget(const RefridgeGoApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Recipes'));
        await tester.pumpAndSettle();
        expect(find.text('Old Recipe'), findsOneWidget);

        await tester.tap(find.text('Clear All'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Clear'));
        await tester.pumpAndSettle();

        expect(find.text('No saved recipes yet'), findsOneWidget);
      },
    );

    testWidgets(
      'Theme toggle switches between light and dark mode',
      (WidgetTester tester) async {
        await tester.pumpWidget(const RefridgeGoApp());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

        await tester.tap(find.byIcon(Icons.dark_mode_outlined));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.light_mode), findsOneWidget);
      },
    );
  });
}
