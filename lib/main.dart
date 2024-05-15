import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onehub_web/firebase_options.dart';
import 'package:onehub_web/quiz_screen.dart';
import 'package:onehub_web/state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(OneHubWeb());
}

class OneHubWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DataState(),
        child: MaterialApp(home: QuizScreen()));
  }
}
