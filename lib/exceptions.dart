class NotImplemented implements Exception {
  final message = 'Not implemented.';
}

class InvalidArgument implements Exception {
  final String message;

  const InvalidArgument([this.message = '']);

  String toString() => 'InvalidArgument: $message';
}
