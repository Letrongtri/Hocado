import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hocado/core/utils/csv_reader.dart';

void main() {
  group("CSV Reader", () {
    CsvReader subject = CsvReader();
    test(
      "WHEN pasing a csv file into the method THEN it should return a table",
      () {
        File file = File("test_data/learn english/lesson_1.csv");
        expect(subject.readLession1(file)[1][1], 'táo');
      },
    );

    test(
      "WHEN pasing a not csv file into the method THEN it should throw error",
      () {
        File file = File("test/data/services/csv_reader_test.dart");
        expect(() => subject.readLession1(file), throwsUnsupportedError);
      },
    );
  });
}
