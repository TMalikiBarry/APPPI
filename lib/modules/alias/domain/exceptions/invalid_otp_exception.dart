/// Quand le code OTP est invalide
class AliasInvalidOtpException implements Exception {
  //
  final String? message;
  final Object? cause;

  ///
  AliasInvalidOtpException({this.message, this.cause});

  @override
  String toString() => '$message <- $cause';
}
