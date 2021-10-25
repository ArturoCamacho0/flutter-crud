// Importamos los paquetes para utilizar en nuestra pantalla
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Creamos nuestro widget con el que tendremos la interfaz
class Update extends StatelessWidget {
  // Pedimos el id como parametro para buscar al que estamos editando
  final String id;
  const Update({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializamos firebase y creamos los campos que van a tener los datos
    final firebase = FirebaseFirestore.instance;
    TextEditingController nombre = TextEditingController();
    TextEditingController edad = TextEditingController();

    // Con esta funcion vamos a actualizar los datos
    update() async {
      if (nombre.text.isNotEmpty && edad.text.isNotEmpty) {
        // Una vez que este verificado los campos procedemos a actualizar al usuario
        try {
          firebase.collection("personas").doc(id).update({
            "nombre": nombre.text,
            "edad": edad.text,
          });
          // Lo regresamos a la pantalla principal
          Navigator.pop(context);
        } catch (e) {
          print(e);
        }
      }
    }

    // Creamos todo lo visual que va a encontrarse en nuestra pantalla
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
            // Creamos el boton para cuando querramos actualizar al usuario
            ElevatedButton(
                onPressed: () {
                  update(); // Llamamos a la funcion
                },
                child: const Text('Guardar'))
          ],
        ),
      ),
    );
  }
}
