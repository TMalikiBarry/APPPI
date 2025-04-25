import '../transaction.dart';

class TransactionSearchFilter {
  TransactionSearchFilter({
    this.dateDebut,
    this.dateFin,
    this.sens,
    required this.categories,
  });
  DateTime? dateDebut;
  DateTime? dateFin;
  List<String> categories;
  TransactionSens? sens;
}
