class MovementHistoryDTO {
  final String author;
  final DateTime creationDate;
  final String guID;
  final String message;
  final String status;

  MovementHistoryDTO({
    required this.author,
    required this.creationDate,
    required this.guID,
    required this.message,
    required this.status,
  });

  factory MovementHistoryDTO.fromJson(Map<String, dynamic> json) {
    return MovementHistoryDTO(
      author: json['author'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      guID: json['guID'] as String,
      message: json['message'] as String,
      status: json['status'] as String,
    );
  }
}
