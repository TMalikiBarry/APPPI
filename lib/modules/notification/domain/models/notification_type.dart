enum NotificationType {
  revendicationInitiee("REVENDICATION_INITIEE"),
  annulationDemandee("ANNULATION_DEMANDEE"),
  annulationRejetee("ANNULATION_REJETEE"),
  annulationAcceptee("ANNULATION_ACCEPTEE"),
  rtpInitiee("RTP_INITIEE"),
  rtpRecue("RTP_RECUE"),
  notifTransaction("TRANSACTION"),
  airtime("AIRTIME"),
  payment("PAYMENT"),
  deposit("DEPOSIT");

  final String value;
  const NotificationType(this.value);

  static NotificationType get(String name) {
    return NotificationType.values.firstWhere(
      (e) => e.value == name,
      orElse: () =>
          throw ArgumentError("Aucune correspondance pour la valeur $name"),
    );
  }

  static List<NotificationType> list() => NotificationType.values;
}
