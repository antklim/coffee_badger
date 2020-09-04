import 'package:coffee_badger/exceptions.dart';
import 'package:coffee_badger/ratio.dart';
import 'package:test/test.dart';

// TODO: Randomize test inputs (use fuzz test technique).
// TODO: Use randomized inputs and combination of ratio, coffeePerWater,
//       and waterPerCoffee to validate methods behaviour.

void main() {
  group('ratio calculator', () {
    test('throws when coffee weight is not positive', () {
      expect(() => ratio(coffee: 0, water: 1),
          throwsA(isA<CoffeeWeightNegativeException>()));
    });

    test('throws when water volume is not positive', () {
      expect(() => ratio(coffee: 1, water: 0),
          throwsA(isA<WaterVolumeNegativeException>()));
    });

    test('calculates coffee/water ratio', () {
      final actual = ratio(coffee: 50, water: 1000);
      expect(actual, equals(20));
    });
  });

  group('coffee per water calculator', () {
    test('throws when ratio value is not positive', () {
      expect(() => coffeePerWater(ratio: 0, water: 1),
          throwsA(isA<RatioValueNegativeException>()));
    });

    test('throws when water volume is not positive', () {
      expect(() => coffeePerWater(ratio: 1, water: 0),
          throwsA(isA<WaterVolumeNegativeException>()));
    });

    test('calculates coffee weight per water volume', () {
      const expected = 16.666;
      final actual = coffeePerWater(ratio: 15, water: 250);
      expect(actual, closeTo(expected, 0.001));
    });
  });

  group('water per coffee calculator', () {
    test('throws when ratio value is not positive', () {
      expect(() => waterPerCoffee(ratio: 0, coffee: 1),
          throwsA(isA<RatioValueNegativeException>()));
    });

    test('throws when coffee weight is not positive', () {
      expect(() => waterPerCoffee(ratio: 1, coffee: 0),
          throwsA(isA<CoffeeWeightNegativeException>()));
    });

    test('calculates water volume per coffee weight', () {
      const expected = 300.000;
      final actual = waterPerCoffee(ratio: 15, coffee: 20);
      expect(actual, closeTo(expected, 0.001));
    });
  });
}
