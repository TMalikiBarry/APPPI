/// Quand le numéro de compte est inconnu
class UnknowAccountException implements Exception {
  //
  final String id;
  final Object? cause;

  ///
  UnknowAccountException({required this.id, this.cause});

  @override
  String toString() => '$id <- $cause';
}
