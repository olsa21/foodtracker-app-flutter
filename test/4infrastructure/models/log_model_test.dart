import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodtracker/4infrastructure/models/LogModel.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final t_LogModelEmptyValues = LogModel(id: null, ean: "123456789", amount: 100.0, date: null, type: "Breakfast");
  final t_LogModelWithDate = LogModel(id: null, ean: "123456789", amount: 100.0, date: "2022-10-09", type: "Breakfast");
  final t_LogModel = LogModel(id: 1, ean: "123456789", amount: 100.0, date: "2022-10-09", type: "Breakfast");

  group("Database Factory", () {
    test("test parsing to DB-JSON with empty date", () {
      final Map<String, dynamic> jsonMap1 = json.decode(fixture("log_db_object_default_date.json"));
      final jsonMap2 = t_LogModelEmptyValues.toDbJson();

      expect(jsonMap1, jsonMap2);
    });

    test("test parsing from DB-JSON", () {
      final Map<String, dynamic> jsonMap1 = json.decode(fixture("log_from_db_object_specific_date.json"));
      final log = LogModel.fromDbJson(jsonMap1);

      expect(log, t_LogModel);
    });
  });
}
