import '../models/alias_error.dart';

/// Exception lors d'une tentive de revendication
class AliasClaimException implements Exception {
  // last known alias
  final String phone;
  final AliasError error;
  final Object? cause;

  AliasClaimException({required this.phone, required this.error, this.cause});

  @override
  String toString() => 'AliasClaimException <- $error + $phone + $cause';
}
