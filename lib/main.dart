import 'package:flutter/material.dart';
import 'package:movies_clone/constants/app_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movies_clone/ui/screens/wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Text("Error");
          else if (snapshot.connectionState == ConnectionState.done)
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: AppThemes.lightThemeData,
              home: Wrapper(),
            );
          else
            return CircularProgressIndicator();
        });
  }
}
