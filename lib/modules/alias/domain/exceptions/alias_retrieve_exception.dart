import '../models/alias.dart';

/// Exception lors d'une tentive de récupération d'alias
class AliasRetrieveException implements Exception {
  // last known alias
  final Alias? alias;
  final Object? error;
  final Object? cause;

  ///
  AliasRetrieveException({this.error, this.alias, this.cause});

  @override
  String toString() => '$alias <- $error + $cause';
}
