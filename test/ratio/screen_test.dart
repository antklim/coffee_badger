import 'package:coffee_badger/ratio/screen.dart';
import 'package:coffee_badger/ratio/state.dart';
import 'package:coffee_badger/ratio/use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// TODO: improve testing with better widget finders
// It should find widget by unique key and asserts widget properties. Now it finds widgets by properties.

void main() {
  group('Ratio Screen', () {
    testWidgets('has header', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RatioScreen()));

      WidgetPredicate header =
          (Widget w) => w is Text && w.data == 'Ratio calculator';

      expect(find.byWidgetPredicate(header), findsOneWidget);
    });

    testWidgets('has ratio settings', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RatioScreen()));

      WidgetPredicate label =
          (Widget w) => w is Text && w.data == 'Set ratio as';

      WidgetPredicate ratioOptions = (Widget w) => w is DropdownButton;

      WidgetPredicate ratioInput = (Widget w) =>
          w is TextField &&
          w.decoration.prefixText == '1:' &&
          w.controller.text == '16.0';

      WidgetPredicate compoundCoffeeRatioInput =
          (Widget w) => w is TextField && w.controller.text == '60.0';

      WidgetPredicate compoundWaterRatioInput =
          (Widget w) => w is TextField && w.controller.text == '1000.0';

      expect(find.byWidgetPredicate(label), findsOneWidget);
      expect(find.byWidgetPredicate(ratioOptions), findsOneWidget);
      expect(find.byWidgetPredicate(ratioInput), findsOneWidget);
      expect(find.byWidgetPredicate(compoundCoffeeRatioInput), findsNothing);
      expect(find.byWidgetPredicate(compoundWaterRatioInput), findsNothing);
    });

    testWidgets('ratio settings can switch between options',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RatioScreen()));

      WidgetPredicate ratioOptions = (Widget w) => w is DropdownButton;

      WidgetPredicate ratioOptionsMIs = (Widget w) => w is DropdownMenuItem;

      WidgetPredicate ratioInput = (Widget w) =>
          w is TextField &&
          w.decoration.prefixText == '1:' &&
          w.controller.text == '16.0';

      WidgetPredicate compoundCoffeeRatioInput =
          (Widget w) => w is TextField && w.controller.text == '60.0';

      WidgetPredicate compoundWaterRatioInput =
          (Widget w) => w is TextField && w.controller.text == '1000.0';

      await tester.tap(find.byWidgetPredicate(ratioOptions));
      await tester.pump();

      await tester.tap(find.byWidgetPredicate(ratioOptionsMIs).last);
      await tester.pump();

      expect(find.byWidgetPredicate(ratioInput), findsNothing);
      expect(find.byWidgetPredicate(compoundCoffeeRatioInput), findsOneWidget);
      expect(find.byWidgetPredicate(compoundWaterRatioInput), findsOneWidget);
    });

    testWidgets('has coffe and water inputs', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RatioScreen()));

      WidgetPredicate brewInputs = (Widget w) =>
          w is TextField &&
          w.controller.text == '0.0' &&
          w.decoration.prefixText == '';

      expect(find.byWidgetPredicate(brewInputs), findsNWidgets(2));
    });

    testWidgets('updates water state when ratio changed',
        (WidgetTester tester) async {
      RatioState state = RatioState();
      state.setBrew(BrewParameter.coffee)('10');

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<RatioState>(
          create: (_) => state,
          builder: (context, _) => RatioScreenContainer(),
        ),
      ));

      WidgetPredicate coffeeInput =
          (Widget w) => w is TextField && w.controller.text == '10.0';

      WidgetPredicate waterInputBefore =
          (Widget w) => w is TextField && w.controller.text == '160.0';

      WidgetPredicate waterInputAfter =
          (Widget w) => w is TextField && w.controller.text == '150.0';

      expect(find.byWidgetPredicate(coffeeInput), findsOneWidget);
      expect(find.byWidgetPredicate(waterInputBefore), findsOneWidget);
      expect(find.byWidgetPredicate(waterInputAfter), findsNothing);

      state.setRatio('15');
      await tester.pumpAndSettle();

      expect(find.byWidgetPredicate(coffeeInput), findsOneWidget);
      expect(find.byWidgetPredicate(waterInputBefore), findsNothing);
      expect(find.byWidgetPredicate(waterInputAfter), findsOneWidget);
    });

    testWidgets('updates water state when coffee changed',
        (WidgetTester tester) async {
      RatioState state = RatioState();
      state.setBrew(BrewParameter.coffee)('10');

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<RatioState>(
          create: (_) => state,
          builder: (context, _) => RatioScreenContainer(),
        ),
      ));

      WidgetPredicate coffeeInput =
          (Widget w) => w is TextField && w.controller.text == '10.0';

      WidgetPredicate waterInputBefore =
          (Widget w) => w is TextField && w.controller.text == '160.0';

      WidgetPredicate waterInputAfter =
          (Widget w) => w is TextField && w.controller.text == '192.0';

      expect(find.byWidgetPredicate(coffeeInput), findsOneWidget);
      expect(find.byWidgetPredicate(waterInputBefore), findsOneWidget);
      expect(find.byWidgetPredicate(waterInputAfter), findsNothing);

      await tester.enterText(find.byWidgetPredicate(coffeeInput), '12');
      await tester.pumpAndSettle();

      expect(find.byWidgetPredicate(waterInputBefore), findsNothing);
      expect(find.byWidgetPredicate(waterInputAfter), findsOneWidget);
    });

    testWidgets('updates coffee state when water changed',
        (WidgetTester tester) async {
      RatioState state = RatioState();
      state.setBrew(BrewParameter.coffee)('10');

      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<RatioState>(
          create: (_) => state,
          builder: (context, _) => RatioScreenContainer(),
        ),
      ));

      WidgetPredicate coffeeInputBefore =
          (Widget w) => w is TextField && w.controller.text == '10.0';

      WidgetPredicate coffeeInputAfter =
          (Widget w) => w is TextField && w.controller.text == '9.4';

      WidgetPredicate waterInput =
          (Widget w) => w is TextField && w.controller.text == '160.0';

      expect(find.byWidgetPredicate(coffeeInputBefore), findsOneWidget);
      expect(find.byWidgetPredicate(coffeeInputAfter), findsNothing);
      expect(find.byWidgetPredicate(waterInput), findsOneWidget);

      await tester.enterText(find.byWidgetPredicate(waterInput), '150');
      await tester.pumpAndSettle();

      expect(find.byWidgetPredicate(coffeeInputBefore), findsNothing);
      expect(find.byWidgetPredicate(coffeeInputAfter), findsOneWidget);
    });
  });
}
