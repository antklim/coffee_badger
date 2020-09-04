import 'package:coffee_badger/exceptions.dart';

/// ratio returns ratio of coffee and water required to brew.
///   - coffee - weight of coffee in grams
///   - water - volume of water in ml
double ratio({double coffee, double water}) {
  if (coffee <= 0) {
    throw CoffeeWeightNegativeException();
  }

  if (water <= 0) {
    throw WaterVolumeNegativeException();
  }

  return water / coffee;
}

/// coffeePerWater returns coffee in grams required to brew for provided amount
/// of water.
///   - ratio - brewing ratio
///   - water - volume of water in ml
double coffeePerWater({double ratio, double water}) {
  if (ratio <= 0) {
    throw RatioValueNegativeException();
  }

  if (water <= 0) {
    throw WaterVolumeNegativeException();
  }

  return water / ratio;
}

/// waterPerCoffee returns volume of water in ml required to brew provided
/// weight of coffee in grams.
///   - ratio - brewing ratio
///   - coffee - weight of coffee in grams
double waterPerCoffee({double ratio, double coffee}) {
  if (ratio <= 0) {
    throw RatioValueNegativeException();
  }

  if (coffee <= 0) {
    throw CoffeeWeightNegativeException();
  }

  return ratio * coffee;
}
