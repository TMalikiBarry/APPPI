import 'notification_search_filter.dart';

class NotificationSearchCommand {
  NotificationSearchCommand({
    required this.filters,
    this.compte,
    this.keyWord,
    this.limit = 10,
    this.index = 0,
    this.total = 0,
  });

  NotificationSearchFilter filters;
  String? compte;
  String? keyWord;
  int limit;
  int index;
  int total;

  /// Méthode pour déterminer si plus de notifications peuvent être chargées
  bool canLoadMore() {
    return (index * limit) < total;
  }
}
