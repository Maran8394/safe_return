// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReportsData {
  final int solved;
  final int unSolved;
  final int total;

  ReportsData({
    required this.solved,
    required this.unSolved,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'solved': solved,
      'unSolved': unSolved,
      'total': total,
    };
  }

  factory ReportsData.fromMap(Map<String, dynamic> map) {
    return ReportsData(
      solved: map['solved'] as int,
      unSolved: map['unSolved'] as int,
      total: map['total'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportsData.fromJson(String source) =>
      ReportsData.fromMap(json.decode(source) as Map<String, dynamic>);
}
