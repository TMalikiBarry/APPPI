class NotificationSearchFilter {
  NotificationSearchFilter({
    this.dateDebut,
    this.dateFin,
    this.types = const []
  });
  DateTime? dateDebut;
  DateTime? dateFin;
  List<String> types;
}
