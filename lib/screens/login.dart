// Importamos los paquetes y archivos que vamos a utilizar
import 'package:crud/screens/home.dart';
import 'package:crud/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Creamos el punto de entrada de la pantalla
class LoginScreen extends StatefulWidget {
  // Creamos las variables para que podamos traer el correo y contraseña
  final Function(String? email, String? password)? onSubmitted;

  const LoginScreen({this.onSubmitted, Key? key}) : super(key: key);
  @override
  // Creamos el estado del widget
  _LoginScreenState createState() => _LoginScreenState();
}

// Creamos el widget que nos dará nuestra interfaz
class _LoginScreenState extends State<LoginScreen> {
  // Creamos nuestras variables que vamos a utilizar
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email, password;
  String? emailError, passwordError;

  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;

  @override
  // Al iniciar asignamos en blanco los campos
  void initState() {
    super.initState();
    email = "";
    password = "";

    emailError = null;
    passwordError = null;
  }

  // Igualmente ponemos en null los errores
  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  // Estas son las validaciones que tenemos para nuestros campos
  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = "El email es incorrecto.";
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Por favor ingrese una contraseña.";
      });
      isValid = false;
    }

    return isValid;
  }

  // Esta funcion sera para cuando hagan submit en la parte del login
  void submit() async {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(email, password);
      }

      // En este estado cambiamos si se muestra el spinner en pantalla
      setState(() {
        showSpinner = true;
      });

      // Con este bloque accedemos a firebase para poder identificarnos
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Home()));
        });

        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        // ignore: invalid_return_type_for_catch_error
        // Si algo sale mal mostraremos el error que ocurrió con un dialog
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Ha ocurrido un error'),
            content:
                Text(e.toString(), style: const TextStyle(color: Colors.red)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // Creamos el widget con el que vamos a crear nuestra interfaz
  @override
  Widget build(BuildContext context) {
    // Con esta variable sabremos la medida de la pantalla para darle tamaño a ciertas cosas
    double screenHeight = MediaQuery.of(context).size.height;

    // Con el modalprogress podremos mostrar una imagen de carga
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * .12),
                const Text(
                  "Bienvenid@,",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * .01),
                Text(
                  "inicia sesión para continuar.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(.6),
                  ),
                ),
                SizedBox(height: screenHeight * .12),
                InputField(
                  // Asignamos los valores de los input a las variables
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  labelText: "Correo electrónico",
                  errorText: emailError,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autoFocus: true,
                ),
                SizedBox(height: screenHeight * .025),
                InputField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  // Cuando se realice la accion de iniciar sesion llamara a la funcion de arriba
                  onSubmitted: (val) => submit(),
                  labelText: "Contraseña",
                  errorText: passwordError,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * .075,
                ),
                FormButton(
                  text: "Iniciar sesión",
                  onPressed:
                      submit, // Igualmente se llama la funcion para el login
                ),
                SizedBox(
                  height: screenHeight * .15,
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Cuando sea nuevo puede ir a registrarse mandandolo con este boton
                      builder: (_) => const RegisterScreen(),
                    ),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: "¿Eres nuev@?, ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "registrate",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

// Creamos el boton del formulario
class FormButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  const FormButton({this.text = "", this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Creamos los campos de texto que vamos a mostrar en nuestra pantalla
class InputField extends StatelessWidget {
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  const InputField(
      {this.labelText,
      this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      this.obscureText = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
