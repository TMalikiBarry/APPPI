import '../models/alias_create_command.dart';

/// Quand l'alias numéro de téléphone est pris
class AliasNotAvailableException implements Exception {
  //
  final AliasCreateCommand alias;
  final Object? cause;

  ///
  AliasNotAvailableException({required this.alias, this.cause});

  @override
  String toString() => '$alias <- $cause';
}
