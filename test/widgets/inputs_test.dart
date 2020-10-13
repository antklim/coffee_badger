import 'package:coffee_badger/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widgets::NumberInput', () {
    WidgetPredicate suffixDecoration =
        (Widget w) => w is SizedBox && w.width == 20 && w.child is Text;

    testWidgets('has default prefix, suffix, and textAlign',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Scaffold(body: const NumberInput())));

      WidgetPredicate input = (Widget w) =>
          w is TextField &&
          w.decoration.prefixText == '' &&
          w.decoration.suffix is SizedBox &&
          w.textAlign == TextAlign.start &&
          w.keyboardType == TextInputType.number &&
          w.maxLength == 5;

      WidgetPredicate suffix =
          (Widget w) => w is Text && w.data == '' && w.style.fontSize == 12;

      expect(find.byWidgetPredicate(input), findsOneWidget);
      expect(find.byWidgetPredicate(suffixDecoration), findsOneWidget);
      expect(find.byWidgetPredicate(suffix), findsOneWidget);
    });

    testWidgets('allows to set prefix, suffix, textAlign, and width',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: const NumberInput(
            prefix: 'hello',
            suffix: 'test',
            textAlign: TextAlign.center,
            width: 43,
          ),
        ),
      ));

      WidgetPredicate input = (Widget w) =>
          w is TextField &&
          w.decoration.prefixText == 'hello' &&
          w.textAlign == TextAlign.center &&
          w.decoration.suffix is SizedBox &&
          w.keyboardType == TextInputType.number &&
          w.maxLength == 5;

      WidgetPredicate suffix =
          (Widget w) => w is Text && w.data == 'test' && w.style.fontSize == 12;

      expect(find.byWidgetPredicate(input), findsOneWidget);
      expect(find.byWidgetPredicate(suffixDecoration), findsOneWidget);
      expect(find.byWidgetPredicate(suffix), findsOneWidget);
    });

    testWidgets('allows to provide on change handler',
        (WidgetTester tester) async {
      String value = '';

      await tester.pumpWidget(
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
              home: Scaffold(
                  body: NumberInput(
            prefix: 'SuperInput',
            onChanged: (String newValue) {
              setState(() {
                value = newValue;
              });
            },
          )));
        }),
      );

      WidgetPredicate input = (Widget w) =>
          w is TextField && w.decoration.prefixText == 'SuperInput';

      expect(find.byWidgetPredicate(input), findsOneWidget);

      await tester.enterText(find.byWidgetPredicate(input), '124');

      await tester.pump();

      expect(value, equals('124'));
    });
  });
}
