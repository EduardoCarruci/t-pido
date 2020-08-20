import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t_pido/src/database/firedb.dart';
import 'package:t_pido/src/model/empresas.dart';
import 'package:t_pido/src/model/rubros.dart';
import 'package:t_pido/src/model/usuario.dart';
import 'package:t_pido/src/screens/Login.dart';
import 'package:t_pido/src/utils/const.dart';
import 'package:t_pido/src/widgets/ContainerText.dart';
import 'package:t_pido/src/widgets/NotFound.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({this.userFirebase});
  Usuario userFirebase;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> arraylocalRubros = new List<String>();
  bool loading = true;
  String opcionvalue = "Por rubro";
  String opcionData = "Seleccionar";
  String empresaFavorita;
  TextEditingController controller = new TextEditingController();
  bool favoritos = false;
  bool search = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    setDataArrayLocal();

    initTime();
    setState(() {});
  }

  void initTime() {
    Timer(const Duration(milliseconds: 10), () {
      if (loading) {
        loading = false;
        setState(() {});
      }
    });
  }

  void setDataArrayLocal() {
    for (int i = 0; i < widget.userFirebase.empresa.length; i++) {
      if (widget.userFirebase.empresa[i].isEmpty) {
        print("NO HAY FAVORITOS");
        favoritos = false;
        return;
      } else {
        print("HAY FAVORITOS");
        favoritos = true;
        break;
      }
    }
  }

// itemCount: value == null ? 0 : value,

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "INICIO",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            centerTitle: true,
            backgroundColor: Utils.mediumBlue,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                }),
            /*  title: Container(
                child:  ), */
          ),
          body: Center(
            child: Container(
              width: width * 0.80,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //loading == true ? LoadingPage() : Center(child: Text("CARGO"))
                      Image.asset(
                        "assets/tpido.png",
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      ContainerText(width: width),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Introduce una Empresa';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    opcionvalue = "Por rubro";
                                    search = true;
                                    setState(() {});
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: controller,
                                  cursorColor: Utils.mediumBlue,
                                  style: TextStyle(
                                    color: Utils.mediumBlue,
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Por nombre",
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
                                  )),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              /*  if (_formKey.currentState.validate()) {
                              } else {} */
                            },
                            icon: Icon(Icons.search),
                            color: Utils.mediumBlue,
                            iconSize: 25,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      ///LEER BIEN
///// EL OBJETIVO ES EVALUAR CADA UNO DE LOS CASOS PARA REPINTAR LA PANTALLA
                      ///
                      ///PRIMERO SE EVALUA SI YA TERMINO DE CARGAR LOS RUBROS PARA PINTAR EL ELEMENTO
                      if (!loading) ...[
                        callRubros(),
                      ],
                      SizedBox(
                        height: 10.0,
                      ),
// SI NO TIENE FAVORITOS
                      if (favoritos == false) ...[
                        if (opcionvalue == "Por rubro" && search) ...[
                          //  SI LA OPCION ES RUBRO Y NO ESTA INTENTANDO BUSCAR ELEMENTOS POR NOMBRE
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Utils.mediumBlue,
                            )),
                            width: width,
                            height: 200.0,
                            child: uniqueEnterprise(), // SE LLAMA A LA FUNCION
                          ),
                        ] else ...[
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Utils.mediumBlue,
                            )),
                            width: width,
                            height: 200.0,
                            child: opcionvalue == "Por rubro"
                                ? Container()
                                : callEmpresas(
                                    width), //  SE LLAMA A TODAS LAS EMPRESAS
                          ),
                        ]
                      ] else if (favoritos) ...[
                        //ACA CARGAR LOS FAVORITOS

                        if (opcionvalue == "Por rubro" && !search) ...[
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Utils.mediumBlue,
                            )),
                            width: width,
                            height: 200.0,
                            child: firebaseEnterprise(
                                width), // SE LLMANA A LAS EMPRESAS
                          ),
                        ] else if (opcionvalue != "Por rubro" && !search) ...[
                          callEmpresas(width)
                        ] else if (opcionvalue == "Por rubro" && search) ...[
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Utils.mediumBlue,
                            )),
                            width: width,
                            height: 200.0,
                            child: uniqueEnterprise(),
                          ),
                        ],
                      ], // recuerdate que en cada caso restablecemos los objetos es decir esperamos a que el cliente escoga un favorito
// o por lo menos hace un pedido
// luego de esas acciones volvemos a restablecer los comandos.
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget firebaseEnterprise(width) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.userFirebase.empresa.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                if (widget.userFirebase.empresa[index] != "") ...[
                  Text(
                    widget.userFirebase.empresa[index],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.shoppingBag,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      print("PEDIDO");

                      //ANALIZANDO LA EMPRESA

                      List<Empresas> tasks = await getUserTaskList(
                          widget.userFirebase.empresa[index]);
                      print(tasks);

                  
                      try {

                            Empresas item = new Empresas(
                        coordenadax: tasks[0].coordenadax,
                        coordenaday: tasks[0].coordenaday,
                        linkform: tasks[0].linkform,
                        distrito: tasks[0].distrito,
                        direccion: tasks[0].direccion,
                        telefono: tasks[0].telefono,
                        lnombre: tasks[0].lnombre,
                        email: tasks[0].email,
                      );
// validamos si los elementos para el pedido es VALIDO


                        if (item.email != null ||
                            item.coordenadax != null ||
                            item.coordenaday != null ||
                            item.linkform != null ||
                            item.direccion != null ||
                            item.telefono != null ||
                            item.lnombre != null ||
                            item.distrito != null) {
                          print(item.coordenadax);
                          print(item.coordenaday);
                          print(item.linkform);
                          print(item.distrito);
                          print(item.direccion);
                          print(item.lnombre);
                          print(item.email);
                          //CECILIA ACA
                          String url = item.linkform /* +
                              '?usp=pp_url&${item.lnombre}=${widget.userFirebase.nombre}&${item.direccion}=${widget.userFirebase.direccion}&${item.distrito}=${widget.userFirebase.distrito}&${item.email}=${widget.userFirebase.email}&${item.telefono}=${widget.userFirebase.telefono}&${item.coordenadax}=${widget.userFirebase.coordenadasX}&${item.coordenaday}=${widget.userFirebase.coordenadasY}' */;
                          print(url);
                          if (await canLaunch(url)) {
                            await launch(url,
                                forceWebView: true, forceSafariVC: true);
                          } else {
                            throw 'Could not launch $url';
                          }
                        } else
                          return;
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ]
              ],
            ),
          );
        });
  }

  Widget uniqueEnterprise() {
    return StreamBuilder(
        stream: getUniqueEmpresas(controller.text.trim()),
        builder: (context, AsyncSnapshot<List<Empresas>> snapshot) {
          if (snapshot.hasError) {
            print("ERROR");
            return Center(
              child: Text("ERROR"),
            );
          }
          List<Empresas> items = snapshot.data;
          print(items);
          if (items == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (items.length == 0) {
            return Center(
              child: NotFound(
                texto: "Pronto novedades en este Rubro",
              ),
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        items[index].nombre,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.shoppingBag,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          pressButonPedido(items[index]);
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            FontAwesomeIcons.heart,
                            color: Utils.mediumBlue,
                          ),
                          onPressed: () {
                            checkArray(items[index].nombre);
                          }),
                    ],
                  ),
                );
              });
        });
  }

  void pressButonPedido(Empresas empresa) async {
    print("PEDIDO");
 
    try {

         Empresas item = new Empresas(
      coordenadax: empresa.coordenadax,
      coordenaday: empresa.coordenaday,
      linkform: empresa.linkform,
      direccion: empresa.direccion,
      distrito: empresa.distrito,
      telefono: empresa.telefono,
      lnombre: empresa.lnombre,
      email: empresa.email,
    );

    print(item.coordenadax);
    print(item.coordenaday);
    print(item.linkform);
    print(item.distrito);
    print(item.direccion);
    print(item.lnombre);
    print(item.email);


      if (item.email != null ||
          item.coordenadax != null ||
          item.coordenaday != null ||
          item.linkform != null ||
          item.direccion != null ||
          item.telefono != null ||
          item.lnombre != null ||
          item.distrito != null) {
            //CECILIA ACA
        String url = item.linkform /* +
            '?usp=pp_url&${item.lnombre}=${widget.userFirebase.nombre}&${item.direccion}=${widget.userFirebase.direccion}&${item.distrito}=${widget.userFirebase.distrito}&${item.email}=${widget.userFirebase.email}&${item.telefono}=${widget.userFirebase.telefono}&${item.coordenadax}=${widget.userFirebase.coordenadasX}&${item.coordenaday}=${widget.userFirebase.coordenadasY}' */;
        print(url);
        if (await canLaunch(url)) {
          await launch(url, forceWebView: true, forceSafariVC: true);
        } else {
          throw 'Could not launch $url';
        }
      } else
        return;
    } catch (e) {
      print(e);
    }
  }

  Widget callEmpresas(width) {
    return StreamBuilder(
        stream: getEmpresas(opcionvalue),
        builder: (context, AsyncSnapshot<List<Empresas>> snapshot) {
          if (snapshot.hasError) {
            print("ERROR");
            return Center(
              child: Text("ERROR"),
            );
          }
          List<Empresas> items = snapshot.data;
          if (items == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (items.length == 0) {
            return Center(
              child: NotFound(
                texto: "Pronto novedades en este Rubro",
              ),
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        items[index].nombre,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.shoppingBag,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          pressButonPedido(items[index]);
                        },
                      ),
                      IconButton(
                          icon: Icon(
                            FontAwesomeIcons.heart,
                            color: Utils.mediumBlue,
                          ),
                          onPressed: () {
                            checkArray(items[index].nombre);
                          }),
                    ],
                  ),
                );
              });
        });
  }

  Widget callRubros() {
    return StreamBuilder(
        stream: getRubros(),
        builder: (context, AsyncSnapshot<List<Rubros>> snapshot) {
          if (!snapshot.hasData) {
            print("ERROR");
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          //List<Rubros> items = snapshot.data;
          if (snapshot.data.length == 0) {
            return NotFound(
              texto: "No hay Rubros..",
            );
          }

          return Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: DropdownButton<Rubros>(
              itemHeight: 50,
              style: TextStyle(color: Colors.black),
              items: snapshot.data
                  .map((data) => DropdownMenuItem<Rubros>(
                        child: Text(
                          data.nombre,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        value: data,
                      ))
                  .toList(),
              onChanged: (Rubros value) {
                opcionvalue = value.nombre;
                print("NAME PRESS: " + value.nombre);
                print(value.uid);
                search = false;
                setState(() {});
              },
              isExpanded: true,
              hint: Text(
                opcionvalue,
                style: TextStyle(fontSize: 16),
              ),
              icon: Icon(Icons.arrow_drop_down),
            ),
          );
        });
  }

  void checkArray(String nombre) {
    bool check = true;
    bool bandera = false;
    print("PRESS FAVORITOS");
    for (int j = 0; j < widget.userFirebase.empresa.length; j++) {
      if (widget.userFirebase.empresa[j] == nombre) {
        check = false;
        setState(() {});
      }
    }
    if (check) {
      for (int i = 0; i < widget.userFirebase.empresa.length; i++) {
        if (widget.userFirebase.empresa[i] == "") {
          widget.userFirebase.empresa[i] = nombre;

          favoritos = true;
          Map<String, dynamic> data = {
            "empresas": widget.userFirebase.empresa,
            "coordenadasX": widget.userFirebase.coordenadasX,
            "coordenadasY": widget.userFirebase.coordenadasY,
            "direccion": widget.userFirebase.direccion,
            "distrito": widget.userFirebase.distrito,
            "email": widget.userFirebase.email,
            "nombre": widget.userFirebase.nombre,
            "telefono": widget.userFirebase.telefono,
            "uid": widget.userFirebase.uid
          };
          print(data);

          Firestore.instance
              .collection("usuarios")
              .document(widget.userFirebase.uid)
              .updateData(data)
              .then((_) => {
                    Firestore.instance
                        .collection("usuarios")
                        .document(widget.userFirebase.uid)
                        .get()
                        .then((DocumentSnapshot result) async => {
                              widget.userFirebase =
                                  Usuario.fromSnapshot(result),
                              print(widget.userFirebase.empresa2),
                            }),
                  });
          bandera = false;
          break;
        } else {
          print("NO HAY ESPACIO");
          bandera = true;
          //break;
        }
      }

      opcionvalue = "Por rubro";
      search = false;
      setState(() {});
      if (bandera) {
        _showMyDialog("Aviso!",
            "Lo sentimos, solo puedes registrar 10 favoritos, si deseas eliminar uno escribenos a contacto@t-pido.com");
        return;
      }
    } else {
      //CREAR EL ALERTA
      print("CHECK FALSE");
      _showMyDialog("Aviso!", "Ya existe algun registro de esta Empresa.");
    }
  }

  Future<void> _showMyDialog(String titulo, String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
