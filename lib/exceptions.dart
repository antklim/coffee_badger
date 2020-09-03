class NotImplementedException implements Exception {
  final message = 'Not implemented.';
}

class CoffeeWeightNegativeException implements Exception {
  final message = 'Coffee weight must be a positive number.';
}

class RatioValueNegativeException implements Exception {
  final message = 'Ratio value must be a positive number.';
}

class WaterVolumeNegativeException implements Exception {
  final message = 'Water volume must be a positive number.';
}
