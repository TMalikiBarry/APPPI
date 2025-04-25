/// Types d'erreurs possibles dans la gestion des alias
enum AliasError {
  //
  unknow,
  connection,
  invalidOtpCode,
  aliasAlreadyExist,
  limitError,
  // Revendications
  aliasNotExist,
  aliasLocked,
  claimNotExist,
  claimClosed;
}
