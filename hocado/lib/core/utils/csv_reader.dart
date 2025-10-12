import 'dart:io';

class CsvReader {
  List<List<String>> readLession1(File file) {
    if (!file.path.endsWith(".csv")) {
      throw UnsupportedError("Only csv is currently supported");
    }

    final rows = file.readAsLinesSync();
    List<List<String>> data = rows.map((String row) => row.split(',')).toList();
    return data;
  }
}
