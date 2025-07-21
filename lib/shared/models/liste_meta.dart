class ListeMeta {
  final int total;
  final int? totalPages;
  final int? size;
  final int? number;

  final String? previous;
  final String? next;
  final String? current;
  final int limit;

  ListeMeta({
    required this.total,
    this.previous,
    this.next,
    this.current,
    this.totalPages,
    this.size,
    this.number,
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

  factory ListeMeta.fromJsonNotification(Map<String, dynamic> json) {
    return ListeMeta(
      total: json['totalElements'] as int,
      previous: json['previous'] as String?,
      next: json['next'] as String?,
      current: json['number']!.toString() as String?,
      limit: json['size'] as int,
      totalPages: json['totalPages'] as int?,
      size: json['size'] as int?,
      number: json['number'] as int?,
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
