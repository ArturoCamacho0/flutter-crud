// Importamos los archivos y paquetes que vamos a utilizar
import 'package:crud/screens/add.dart';
import 'package:crud/screens/login.dart';
import 'package:crud/screens/update.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Creamos el punto de entrada en nuestra pantalla
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  // Creamos el estado de nuestra aplicación
  _UsersList createState() => _UsersList();
}

// Creamos nuestra interfaz pero esta vez con estado
class _UsersList extends State<Home> {
  // Inicializamos firebase para utilizarlo
  var firebase = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Con esta funcion tomamos al usuario que inició sesión
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // Nos conectamos a firebase para traer al usuario que inició sesión
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        User loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // En esta función podemos borrar registros con su id
  delete(id) async {
    try {
      firebase
          .collection("personas")
          .doc(id)
          .delete()
          .then((value) => print('Borrado'));
    } catch (e) {
      print(e);
    }
  }

  // Creamos el widget completo de nuestra interfaz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personas')),
      body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // En este boton cambiamos de pagina para agregar un registro
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Add(),
                  ),
                ),
                child: const Text('Agregar persona'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                  onPrimary: Colors.black,
                ),
              ),
              const Divider(),
              // Aqui es donde vamos a listar nuestros registros
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: StreamBuilder<QuerySnapshot>(
                  stream: firebase.collection("personas").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          // Traemos los datos de la colección
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            QueryDocumentSnapshot x = snapshot.data!.docs[i];
                            return ListTile(
                              title: Text(x['nombre']),
                              subtitle: Text(x['edad'].toString()),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Update(id: x.id)),
                              ),
                              trailing: TextButton(
                                // Si presiona el boton para eliminar les mostramos un alertdialog
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Eliminar'),
                                    content: const Text(
                                        '¿Está segur@ de que quiere elimninar la persona?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          delete(x.id);
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('Eliminar',
                                            style: TextStyle(
                                                color: Colors.redAccent)),
                                      ),
                                    ],
                                  ),
                                ),
                                child: const Text('Eliminar',
                                    style: TextStyle(color: Colors.redAccent)),
                              ),
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          )),
      // Creamos un boton para poder salir de nuestra sesión
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _auth.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        icon: const Icon(Icons.close),
        label: const Text('Cerrar sesion'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
