import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/presentation/number_trivia/pages/number_trivia_page.dart';
import 'package:logging/logging.dart';

import 'injection_container.dart' as dependencyInjection;

void main() async {
  _setupLogging();
  await dependencyInjection.init();
  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}
