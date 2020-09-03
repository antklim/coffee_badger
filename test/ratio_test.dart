import 'package:coffee_badger/exceptions.dart';
import 'package:coffee_badger/ratio.dart';
import 'package:flutter_test/flutter_test.dart';

// TODO: Randomize test inputs (use fuzz test technique)

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

    test('calculates coffee/water ratio', () {});
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

    test('calculates coffee weight per water volume', () {});
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

    test('calculates water volume per coffee weight', () {});
  });
}
