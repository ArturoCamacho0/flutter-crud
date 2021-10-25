// Importamos los paquetes y archivos que vamos a estar utilizando
import 'package:crud/screens/login.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Creamos nuestro punto de entrada a la pantalla
class RegisterScreen extends StatefulWidget {
  /// Creamos unos parametros para los campos del email y el password
  final Function(String? email, String? password)? onSubmitted;

  const RegisterScreen({this.onSubmitted, Key? key}) : super(key: key);

  @override
  // Creamos el estado de nuestro widget
  _RegisterScreenState createState() => _RegisterScreenState();
}

// Creamos nuestro widget para la interfaz
class _RegisterScreenState extends State<RegisterScreen> {
  // Creamos nuestras variables para utilizarlas en esta pantalla
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email, password, confirmPassword;
  String? emailError, passwordError;
  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;

  // Iniciamos el estado con las variables vacias
  @override
  void initState() {
    super.initState();
    email = "";
    password = "";
    confirmPassword = "";

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  // Creamos las validaciones correspondientes
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

    if (password.isEmpty || confirmPassword.isEmpty || password.length < 6) {
      setState(() {
        passwordError =
            "Por favor ingrese una contraseña mayor a 6 caracteres.";
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = "Las contraseñas no coinciden.";
      });
      isValid = false;
    }

    return isValid;
  }

  // Creamos la funcion para cuando hagamos submit después
  void submit() async {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(email, password);
      }

      // Mostramos la carga de pantalla
      setState(() {
        showSpinner = true;
      });

      // Creamos a nuestro usuario luego de validar los campos
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  // Lo mandamos a la pagina del login
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen()))
                });
        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        // ignore: invalid_return_type_for_catch_error
        // Si sucede algun error mostramos un dialog con el error
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

  @override
  Widget build(BuildContext context) {
    // Tomamos las medidas de la pantalla para crear algunos elementos
    double screenHeight = MediaQuery.of(context).size.height;

    // Comenzamos con el modal para cuando se encuentre cargando
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * .12),
                const Text(
                  "Crea una cuenta,",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * .01),
                Text(
                  "registrate para ingresar!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(.6),
                  ),
                ),
                SizedBox(height: screenHeight * .12),
                InputField(
                  // Le damos los valores a las variables con los que estan en los inputs
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
                  labelText: "Contraseña",
                  errorText: passwordError,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: screenHeight * .025),
                InputField(
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value;
                    });
                  },
                  onSubmitted: (value) => submit(),
                  labelText: "Escribe de nuevo tu contraseña",
                  errorText: passwordError,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: screenHeight * .075,
                ),
                FormButton(
                  text: "Registrarse",
                  onPressed: submit, // Cuando demos enter se subiran los datos
                ),
                SizedBox(
                  height: screenHeight * .125,
                ),
                TextButton(
                  // Si ya tienen cuenta pueden regresar al inicio de sesión
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: "Ya tengo cuenta, ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "iniciar sesión",
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

// Creamos el boton para los formularios
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

// Creamos los elementos que vamos a utilizar en nuestro formulario
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
