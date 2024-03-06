import 'package:equatable/equatable.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';

class LogModel extends LogEntity with EquatableMixin {
  LogModel(
      {int? id,
      required String ean,
      required double amount,
      String? date,
      required String type})
      : super(id: id, ean: ean, amount: amount, date: date, type: type);

  Map<String, dynamic> toDbJson() {
    return {
      'l_id': id,
      'f_ean': ean,
      'l_amount': amount,
      'l_date': date ?? "datetime('now','localtime')",
      'l_type': type
    };
  }

  factory LogModel.fromDomain(LogEntity logEntity) {
    return LogModel(
        id: logEntity.id,
        ean: logEntity.ean,
        amount: logEntity.amount,
        type: logEntity.type,
        date: logEntity.date);
  }

  factory LogModel.fromDbJson(Map<String, dynamic> map) {
    return LogModel(
        id: map['l_id'] as int,
        ean: map['f_ean'].toString(),
        amount: map['l_amount'] as double,
        date: map['l_date'] as String,
        type: map['l_type'] as String);
  }

  factory LogModel.empty() {
    return LogModel(id: 0, ean: "0", amount: 0, date: "0", type: "0");
  }

  @override
  List<Object?> get props => [id, ean, amount, date, type];
}
