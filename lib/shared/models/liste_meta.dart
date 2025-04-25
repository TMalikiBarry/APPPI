class ListeMeta {
  final int total;
  final String? previous;
  final String? next;
  final String? current;
  final int limit;

  ListeMeta({
    required this.total,
    this.previous,
    this.next,
    this.current,
    required this.limit,
  });

  factory ListeMeta.fromJson(Map<String, dynamic> json) {
    return ListeMeta(
      total: json['total'] as int,
      previous: json['previous'] as String?,
      next: json['next'] as String?,
      current: json['current'] as String?,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total.toString(),
      'limit': limit.toString(),
      'previous': previous,
      'current': current,
      'next': next,
    };
  }
}
