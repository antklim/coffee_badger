import 'package:coffee_badger/ratio/screen.dart';
import 'package:coffee_badger/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

      WidgetPredicate ratioInput =
          (Widget w) => w is TextField && w.decoration.prefixText == '1:';

      // TODO: should be a better way to test it
      WidgetPredicate compoundRatioInputs =
          (Widget w) => w is Text && w.data == '/';

      expect(find.byWidgetPredicate(label), findsOneWidget);
      expect(find.byWidgetPredicate(ratioOptions), findsOneWidget);
      expect(find.byWidgetPredicate(ratioInput), findsOneWidget);
      expect(find.byWidgetPredicate(compoundRatioInputs), findsNothing);
    });

    testWidgets('ratio settings can switch between options',
        (WidgetTester tester) async {},
        skip: true);

    testWidgets('has coffe and water inputs', (WidgetTester tester) async {},
        skip: true);

    testWidgets('updates water state when ratio changed',
        (WidgetTester tester) async {},
        skip: true);

    testWidgets('updates water state when coffee changed',
        (WidgetTester tester) async {},
        skip: true);

    testWidgets('updates coffee state when water changed',
        (WidgetTester tester) async {},
        skip: true);
  });
}
