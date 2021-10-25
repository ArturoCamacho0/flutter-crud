// Añadimos los paquetes para poder utilzar flutter y firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Creamos nuestro componente para agregar registros
class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Creamos la instancia de firebase para utilizarlo
    final firebase = FirebaseFirestore.instance;
    // Creamos los campos para guardar los datos
    TextEditingController nombre = TextEditingController();
    TextEditingController edad = TextEditingController();

    // En esta funcion vamos a crear el registro
    create() async {
      if (nombre.text.isNotEmpty && edad.text.isNotEmpty) {
        try {
          await firebase
              .collection("personas")
              .doc()
              .set({"nombre": nombre.text, "edad": edad.text});
          Navigator.pop(context);
        } catch (e) {
          print(e);
        }
      }
    }

    // Creamos la interfaz de nuestra pantalla
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar persona')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Ingresa los datos para agregar a la persona',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
                controller: nombre,
                decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ))),
            const SizedBox(
              height: 15,
            ),
            TextField(
                controller: edad,
                decoration: InputDecoration(
                    labelText: "Edad",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ))),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  create();
                },
                child: const Text('Guardar'))
          ],
        ),
      ),
    );
  }
}
