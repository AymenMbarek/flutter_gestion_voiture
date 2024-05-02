import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Créez une instance de FirebaseOptions avec vos configurations spécifiques
  FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyDkMxl11V2x_G1aVy-anV4OY0yeGIZpuFE",
    appId: "1:839184861422:android:c275bd8355b4e45fc3cbff",
    messagingSenderId: "839184861422",
    projectId: "location-67102",
  );

  // Initialisez Firebase en utilisant les options spécifiques
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helmi Rent A car',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
