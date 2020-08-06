import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:t_pido/src/database/db.dart';
import 'package:t_pido/src/model/documento.dart';
import 'package:t_pido/src/utils/const.dart';
import 'package:t_pido/src/widgets/CustomFlush.dart';
import 'package:t_pido/src/widgets/Loader.dart';
import 'package:t_pido/src/widgets/TextField.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Position _position;
  StreamSubscription<Position> _positionStream;
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerNombre = new TextEditingController();
  TextEditingController controllerDireccion = new TextEditingController();
  TextEditingController controllerDistrito = new TextEditingController();
  TextEditingController controllerTelefono = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

  bool terminos = true;
  bool politicas = true;
  bool notificaciones = false;
  Documento items;

  @override
  void initState() {
    super.initState();
    getDocument();
    _gpsService();
    getLocation();
  }

  void getDocument() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('documentos').getDocuments();

    items = Documento.fromSnapshot(snapshot.documents[0]);
    print(items.politicas);
    print(items.terminos);
  }

  void getLocation() async {
    try {
      var locationOptions = LocationOptions(accuracy: LocationAccuracy.high);
      _positionStream = await geolocator
          .getPositionStream(locationOptions)
          .listen((Position position) {
        setState(() {
          _position = position;
        });
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  Future _gpsService() async {
    if (!(await geolocator.isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }

  Future _checkGps() async {
    if (!(await geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("No pude obtener tu direccion"),
                content: const Text('Por favor asegurate de activar el Gps.'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        _gpsService();
                      })
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 150,
                        width: size.width,
                        color: Utils.mediumBlue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "Login");
                                  },
                                  alignment: Alignment.topLeft,
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Registrar Usuario',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, left: 20, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          //X
                          containerrows(
                              "Email",
                              controllerEmail,
                              "Oblitagorio",
                              (Icons.alternate_email),
                              TextInputType.emailAddress,false),
                          containerrows(
                              "Nombre y Apellido",
                              controllerNombre,
                              "Oblitagorio",
                              (Icons.verified_user),
                              TextInputType.text,false),
                          containerrows("Direccion", controllerDireccion,
                              "Oblitagoria", (Icons.store), TextInputType.text,false),
                          containerrows(
                              "Distrito",
                              controllerDistrito,
                              "Oblitagorio",
                              (Icons.assignment),
                              TextInputType.text,false),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 80,
                                    child: Text("Telefono",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[900]))),
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (!(value.length >= 7) ||
                                          value.isEmpty) {
                                        return "Fijo (7 digitos) Celular (9 digitos)";
                                      }
                                      return null;
                                    },

                                    //textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,

                                    controller: controllerTelefono,
                                    cursorColor: Utils.mediumBlue,
                                    style: TextStyle(
                                      color: Utils.mediumBlue,
                                      fontSize: 14.0,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Utils.mediumBlue),
                                      focusColor: Utils.mediumBlue,
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: Utils.mediumBlue),
                                      ),
                                      //labelText: hintText,
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        size: 18,
                                        color: Utils.mediumBlue,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          containerrows("Contraseña", controllerPassword,
                              "Oblitagoria", (Icons.lock), TextInputType.text,true),
                          SizedBox(
                            height: 5.0,
                          ),
                          /*     _position == null
                              ? CircularProgressIndicator()
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.pin_drop,
                                        color: Colors.orange[600], size: 30),
                                    Text(
                                      "" +
                                          _position.latitude.toString() + //Y
                                          " " +
                                          _position.longitude.toString(),
                                      style: TextStyle(color: Utils.mediumBlue),
                                    )
                                  ],
                                ), */
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Checkbox(
                                  value: terminos,
                                  onChanged: (bool value) {
                                    terminos = value;
                                    setState(() {});
                                  },
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    String url = items.terminos;
                                    print(url);
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    "Acepto términos y condiciones",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Checkbox(
                                  value: politicas,
                                  onChanged: (bool value) {
                                    politicas = value;
                                    setState(() {});
                                  },
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    String url = items.politicas;
                                    print(url);
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    "Acepto política de privacidad",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Checkbox(
                                  value: notificaciones,
                                  onChanged: (bool value) {
                                    notificaciones = value;
                                    setState(() {});
                                  },
                                ),
                                Text("Acepto envío de notificaciones",
                                    style: Utils.colorRow),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 5.0,
                          ),
                          Center(
                            child: MaterialButton(
                              elevation: 20,
                              color: Utils.mediumBlue,
                              minWidth: width * 0.60,
                              onPressed: () async {
                                // _getCurrentLocation();
                                // requestLocationPermission();
                                _gpsService();

                                save();
                              },
                              child: Center(
                                child: Text("Registrar",
                                    style: Utils.stylebuttons),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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

/**
 * terminos 
politicas
 */
  void save() async {
    if (_formKey.currentState.validate() &&
        _position != null &&
        terminos &&
        politicas) {
      loader();
      try {
        // ColorLoader3();
        var currentUser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: controllerEmail.text.trim(),
                password: controllerPassword.text.trim());

        var setCurrentUser = await Firestore.instance
            .collection("usuarios")
            .document(currentUser.user.uid)
            .setData({
          "uid": currentUser.user.uid,
          "email": controllerEmail.text.trim(),
          "nombre": controllerNombre.text.trim(),
          "direccion": controllerDireccion.text.trim(),
          "distrito": controllerDistrito.text.trim(),
          "telefono": controllerTelefono.text.trim(),
          "empresas": ["", "", "", "", "", "", "", "", "", ""],
          "coordenadasX": _position.longitude.toString(),
          "coordenadasY": _position.latitude.toString(),
          "terminos": "Aceptado",
          "politicas": "Aceptado",
          if (notificaciones) ...{
            "notificaciones": "Activado",
          },
        });
        ClientDatabaseProvider.db.addUserRegister(controllerEmail.text.trim());
        Navigator.pop(context);

        CustomFlush().showCustomBar(context, "Creado");
        Timer(Duration(milliseconds: 1000), () {
          Navigator.pop(context);

          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Login()));
        });
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
          case "The given password is invalid. [ Password should be at least 6 characters ]":
            message = "La contraseña debe tener por lo mínimo 6 caracteres.";
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
      CustomFlush().showCustomBar(
          context, "Debes completar los campos y aceptar Términos y Política");
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  Widget containerrows(String labeltext, TextEditingController controller,
      String validator, IconData icono, TextInputType inputType ,bool obscureText) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 80,
              child: Text(labeltext,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue[900]))),
          Expanded(
            child: TextFieldWidget(
              hintText: validator,
              controller: controller,
              inputType: inputType,
              obscureText: obscureText,
              prefixIconData: icono,
            ),
          )
        ],
      ),
    );
  }
}

/*  
                }).then((result) {
                  ClientDatabaseProvider.db
                      .addUserRegister(controllerEmail.text.trim());
                  Navigator.pop(context);

                  CustomFlush().showCustomBar(context, "Creado");
                  Timer(Duration(milliseconds: 1000), () {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Login()));
                  });
                }).catchError((err) {
                  Navigator.pop(context);
                  CustomFlush().showCustomBar(context, err.toString());
                  Timer(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });

                  print(err);
                }))
            .catchError((err) {
          Navigator.pop(context);
          CustomFlush().showCustomBar(context, err.toString());
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          print(err);
        }); */
