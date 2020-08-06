import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_pido/src/model/usuario.dart';
import 'package:t_pido/src/utils/const.dart';
import 'package:t_pido/src/widgets/CustomFlush.dart';
import 'package:t_pido/src/widgets/Loader.dart';
import 'Example.dart';
import 'Home.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerEmailRecovery = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  Usuario localUser;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onBackPressed,
      child: Scaffold(
        body: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                /*  scrollDirection: Axis.vertical, */
                shrinkWrap: true,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            "assets/tpido.png",
                            fit: BoxFit.cover,
                            height: 250,
                            width: 250,
                          ),
                        ),
                        /* SizedBox(
                                height: 15.0,
                              ), */
                        inputfield("Ingresa el correo", controllerEmail,
                            Icons.alternate_email, "Email"),
                        SizedBox(
                          height: 15.0,
                        ),
                        inputfield("Ingresa la contraseña", controllerPassword,
                            Icons.lock, "Contraseña"),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                save();
                              },
                              minWidth: width / 4,
                              height: 50,
                              elevation: 20,
                              color: Utils.mediumBlue,
                              child: Center(
                                child:
                                    Text("Ingresar", style: Utils.stylebuttons),
                              ),
                            ),
                            MaterialButton(
                              minWidth: width / 4,
                              height: 50,
                              elevation: 20,
                              color: Colors.orange,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OnboardingScreen()),
                                );
                              },
                              child: Text(
                                "Nuevo usuario",
                                style: Utils.stylebuttons,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () async {
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          '¿Deseas cambiar tu contraseña?'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Por favor introduce tu correo:'),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            inputfield(
                                                "Ingresa el correo a recuperar",
                                                controllerEmailRecovery,
                                                Icons.email,
                                                "Correo Electronico"),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              controllerEmailRecovery.clear();
                                              Navigator.of(context).pop();
                                            }),
                                        FlatButton(
                                          child: Text('Restablecer'),
                                          onPressed: () async {
                                            if (controllerEmailRecovery.text !=
                                                "") {
                                              await FirebaseAuth.instance
                                                  .sendPasswordResetEmail(
                                                      email:
                                                          controllerEmailRecovery
                                                              .text
                                                              .trim())
                                                  .then((value) async {
                                                Navigator.pop(context);
                                                CustomFlush().showCustomBar(
                                                    context, "Correo Enviado.");
                                                /* Timer(Duration(seconds: 3), () {
                                                  Navigator.pop(context);
                                                }); */
                                              });
                                            } else {
                                              return;
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text("Olvidé mi contraseña",
                                style: Utils.textBlueShade900)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

    Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Seguro que quieres salir \nde t-pido?'),
         
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('SI'),
                onPressed: () {
                 SystemNavigator.pop();
                  //Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  Widget containerSpace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //Align(alignment: Alignment.bottomCenter,child: Container(child: Text("hola"),)),
      ],
    );
  }

  void save() async {
    if (_formKey.currentState.validate()) {
      loader();
      try {
        AuthResult currentUser = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: controllerEmail.text.trim(),
                password: controllerPassword.text.trim());

        DocumentSnapshot result = await Firestore.instance
            .collection("usuarios")
            .document(currentUser.user.uid)
            .get();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      userFirebase: Usuario.fromSnapshot(result),
                    )));
      } on PlatformException catch (e) {
        String message;

        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            message =
                "No hay registro de usuario correspondiente a este identificador. El usuario puede haber sido eliminado.";
            break;
          case 'The password is invalid or the user does not have a password.':
            message =
                "La contraseña no es válida o el usuario no tiene una contraseña.";
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            message =
                "Se ha producido un error de red (como tiempo de espera, conexión interrumpida o host inaccesible).";
            break;

          case "The email address is already in use by another account.":
            message = "El email ya esta registrado";
            break;

          case "The email address is badly formatted.":
            message = "Correo inválido";
            break;
          // ...
          default:
            print(e.message);
            message = "Ocurrio algun error intente mas tarde";
        }
        Navigator.pop(context);
        CustomFlush().showCustomBar(context, message.toString());
        Timer(Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      CustomFlush().showCustomBar(context, "Debes completar los campos");
      Timer(Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    }
  }

  Future<bool> loader() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: ColorLoader3(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget expanded() {
    return Expanded(
      child: Container(),
    );
  }

  Widget inputfield(String validator, TextEditingController controller,
      prefixIconData, String labeltext) {
    return TextFormField(
      obscureText: validator == "Ingresa la contraseña" ? true : false,
      controller: controller,
      cursorColor: Utils.mediumBlue,
      style: TextStyle(
        color: Utils.mediumBlue,
        fontSize: 17.0,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Utils.mediumBlue),
        focusColor: Utils.mediumBlue,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Utils.mediumBlue),
        ),
        // labelText: labeltext,
        //helperText: labeltext,
        hintText: labeltext,
        prefixIcon: Icon(
          prefixIconData,
          size: 16,
          color: Utils.mediumBlue,
        ),
      ),
    );
  }
}
