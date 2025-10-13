import 'package:flutter/material.dart';
// import 'package:hocado/core/utils/csv_reader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // final CsvReader csvReader = CsvReader();
  // List<List<String>> fcData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flash card app")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(child: Text("Home page")),
      ),
    );
  }
}
