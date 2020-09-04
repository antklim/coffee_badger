import 'package:coffee_badger/exceptions.dart';

/// Calculates brew ratio for a given [coffee] weight in grams and [water]
/// volume in ml.
///
/// Throws a [CoffeeWeightNegativeException] if the coffee weight is not valid.
/// Throws a [WaterVolumeNegativeException] if the water volume is not valid.
double ratio({double coffee, double water}) {
  if (coffee <= 0) {
    throw CoffeeWeightNegativeException();
  }

  if (water <= 0) {
    throw WaterVolumeNegativeException();
  }

  return water / coffee;
}

/// Calculates coffee weight in grams required to brew for a given [ratio] value
/// and [water] volume in ml.
///
/// Throws a [RatioValueNegativeException] if the ratio value is not valid.
/// Throws a [WaterVolumeNegativeException] if the water volume is not valid.
double coffeePerWater({double ratio, double water}) {
  if (ratio <= 0) {
    throw RatioValueNegativeException();
  }

  if (water <= 0) {
    throw WaterVolumeNegativeException();
  }

  return water / ratio;
}

/// Calculates water volume in ml required to brew for a given [ratio] value and
/// [coffee] weight in grams.
///
/// Throws a [RatioValueNegativeException] if the ratio value is not valid.
/// Throws a [CoffeeWeightNegativeException] if the coffee weight is not valid.
double waterPerCoffee({double ratio, double coffee}) {
  if (ratio <= 0) {
    throw RatioValueNegativeException();
  }

  if (coffee <= 0) {
    throw CoffeeWeightNegativeException();
  }

  return ratio * coffee;
}
