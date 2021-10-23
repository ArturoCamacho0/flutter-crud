import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Update extends StatelessWidget {
  final String id;
  const Update({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    TextEditingController nombre = TextEditingController();
    TextEditingController edad = TextEditingController();

    update() async {
      if (nombre.text.isNotEmpty && edad.text.isNotEmpty) {
        print(edad.text);
        try {
          firebase.collection("personas").doc(id).update({
            "nombre": nombre.text,
            "edad": edad.text,
          });
          Navigator.pop(context);
        } catch (e) {
          print(e);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar persona')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Ingresa los nuevos datos de la persona',
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
                  update();
                },
                child: const Text('Guardar'))
          ],
        ),
      ),
    );
  }
}
