class IdentificationException implements Exception {
  //
  final String message;
  final Object? exception;

  ///
  IdentificationException(this.message, [this.exception]);

  @override
  String toString() => '$message <- $exception';
}
