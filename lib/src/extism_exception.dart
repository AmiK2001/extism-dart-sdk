class ExtismException implements Exception {
  final String message;

  ExtismException(this.message);

  @override
  String toString() => "ExtismException: $message";
}
