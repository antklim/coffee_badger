import 'package:coffee_badger/exceptions.dart';
import 'package:coffee_badger/ratio/ratio.dart';
import 'package:test/test.dart';

void main() {
  group('ratio calculator', () {
    test('throws when coffee weight is not positive', () {
      expect(() => compoundRatio(coffee: 0, water: 1),
          throwsA(isA<InvalidArgument>()));
    });

    test('throws when water volume is negative', () {
      expect(() => compoundRatio(coffee: 1, water: -1),
          throwsA(isA<InvalidArgument>()));
    });

    test('calculates coffee/water ratio', () {
      final actual = compoundRatio(coffee: 50, water: 1000);
      expect(actual, equals(20));
    });
  });

  group('coffee per water calculator', () {
    test('throws when ratio value is not positive', () {
      expect(() => coffeePerWater(ratio: 0, water: 1),
          throwsA(isA<InvalidArgument>()));
    });

    test('throws when water volume is negative', () {
      expect(() => coffeePerWater(ratio: 1, water: -1),
          throwsA(isA<InvalidArgument>()));
    });

    test('calculates coffee weight per water volume', () {
      const expected = 16.666;
      final actual = coffeePerWater(ratio: 15, water: 250);
      expect(actual, closeTo(expected, 0.001));
    });
  });

  group('water per coffee calculator', () {
    test('throws when ratio is negative', () {
      expect(() => waterPerCoffee(ratio: -1, coffee: 1),
          throwsA(isA<InvalidArgument>()));
    });

    test('throws when coffee weight negative', () {
      expect(() => waterPerCoffee(ratio: 1, coffee: -1),
          throwsA(isA<InvalidArgument>()));
    });

    test('calculates water volume per coffee weight', () {
      const expected = 300.000;
      final actual = waterPerCoffee(ratio: 15, coffee: 20);
      expect(actual, closeTo(expected, 0.001));
    });
  });
}
