// Importacion de los paquetes y archivos que vamos a utilizar
import 'package:flutter/material.dart';
import 'package:crud/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';

// Declaramos el punto de entrada de nuestra aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializamos los widgets
  await Firebase
      .initializeApp(); // Inicializamos igualmente firebase para utilizarlo
  runApp(const MyApp());
}

// Creamos nuestra base del proyecto
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Login',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
