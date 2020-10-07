import 'package:coffee_badger/exceptions.dart';

enum RatioType { absolute, compound }
var ratioTypes = <RatioType, String>{
  RatioType.absolute: 'Absolute value',
  RatioType.compound: 'Coffee per water'
};

/// Calculates brew ratio for a given [coffee] weight in grams and [water]
/// volume in ml.
///
/// Throws a [InvalidArgument] if the coffee weight or water volume is not valid.
double compoundRatio({double coffee, double water}) {
  if (coffee <= 0) {
    throw InvalidArgument('coffee');
  }

  if (water < 0) {
    throw InvalidArgument('water');
  }

  return water / coffee;
}

/// Calculates coffee weight in grams required to brew for a given [ratio] value
/// and [water] volume in ml.
///
/// Throws a [InvalidArgument] if the ratio value or water volume is not valid.
double coffeePerWater({double ratio, double water}) {
  if (ratio <= 0) {
    throw InvalidArgument('ratio');
  }

  if (water < 0) {
    throw InvalidArgument('water');
  }

  return water / ratio;
}

/// Calculates water volume in ml required to brew for a given [ratio] value and
/// [coffee] weight in grams.
///
/// Throws a [InvalidArgument] if the ratio value or coffee weight is not valid.
double waterPerCoffee({double ratio, double coffee}) {
  if (ratio < 0) {
    throw InvalidArgument('ratio');
  }

  if (coffee < 0) {
    throw InvalidArgument('coffee');
  }

  return ratio * coffee;
}
