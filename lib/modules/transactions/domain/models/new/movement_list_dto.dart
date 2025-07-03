import 'movement_details_dto.dart';

class MovementListDTO {
  final int code;
  final String reason;
  final List<MovementDetailsDTO> data;
  final int page;
  final int size;
  final int total;
  final double totalAmount;

  MovementListDTO({
    required this.code,
    required this.reason,
    required this.data,
    required this.page,
    required this.size,
    required this.total,
    required this.totalAmount,
  });

  factory MovementListDTO.fromJson(Map<String, dynamic> json) {
    return MovementListDTO(
      code: json['code'] as int,
      reason: json['reason'] as String,
      data: (json['data'] as List)
          .map((e) => MovementDetailsDTO.fromJson(e))
          .toList(),
      page: json['page'] as int,
      size: json['size'] as int,
      total: json['total'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}