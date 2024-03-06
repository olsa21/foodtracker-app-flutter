import 'package:equatable/equatable.dart';

class LogEntity with EquatableMixin {
  final int? id;
  final String ean;
  final double amount;
  final String? date;
  final String type;

  LogEntity(
      {this.id,
      required this.ean,
      required this.amount,
      this.date,
      required this.type});

  LogEntity copyWith({
    int? id,
    String? ean,
    double? amount,
    String? date,
    String? type,
  }) {
    return LogEntity(
      id: id ?? this.id,
      ean: ean ?? this.ean,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, ean, amount, date, type];
}
