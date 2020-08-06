import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_pido/src/utils/const.dart';

import 'Register.dart';
//CREAMOS LAS PANTALLAS DE PRESETANCION
class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
// PROPOSITO RECREAR LAS PANTALLAS
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                decoration: BoxDecoration(
                    //color: Colors.blue,
                    ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        height: 50,
                      ),
                      Container(
                        height: 600.0,
                        //color: Colors.red,
                        child: PageView(
                          physics: ClampingScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  /*  SizedBox(height: 20,), */
                                  Container(
                                    color: Utils.mediumBlue,
                                    child: Center(
                                      child: Text(
                                        "PARA REGISTRARTE",
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        height: 400,
                                        width: double.infinity,
                                        color:
                                            Utils.mediumBlue.withOpacity(.25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Completa tus datos",
                                                style: TextStyle(
                                                    color: Color(0xff0276b4),
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Image.asset(
                                              "assets/system.png",
                                              height: 200,
                                              width: 200.0,
                                            ),
                                            Text("Tu usuario será el correo",
                                                style: TextStyle(
                                                    fontFamily: "Lato")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Todos los datos son confidenciales",
                                    style: TextStyle(
                                        color: Utils.mediumBlue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  /*  SizedBox(height: 20,), */
                                  Container(
                                    color: Utils.mediumBlue,
                                    child: Center(
                                      child: Text(
                                        "PARA BUSCAR",
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        height: 400,
                                        width: double.infinity,
                                        color:
                                            Utils.mediumBlue.withOpacity(.25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Opciones de búsqueda",
                                                style: TextStyle(
                                                    color: Colors.brown,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Image.asset(
                                              "assets/search.png",
                                              height: 200,
                                              width: 200.0,
                                            ),
                                            Text(
                                              "Por nombre de empresa",
                                              style:
                                                  TextStyle(fontFamily: "Lato"),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Por rubro",
                                              style:
                                                  TextStyle(fontFamily: "Lato"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 76,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  /*  SizedBox(height: 20,), */
                                  Container(
                                    color: Utils.mediumBlue,
                                    child: Center(
                                      child: Text(
                                        "PARA PEDIR",
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        height: 400,
                                        width: double.infinity,
                                        color:
                                            Utils.mediumBlue.withOpacity(.25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Escoge tu proveedor",
                                                style: TextStyle(
                                                    color: Color(0xFF04957c),
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Image.asset(
                                              "assets/phone.png",
                                              height: 200,
                                              width: 200.0,
                                            ),
                                            Text(
                                              "Click en la bolsa para iniciar tu pedido",
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(fontFamily: "Lato"),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Click en el corazón para guardar el proveedor en tu próximo pedido",
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(fontFamily: "Lato"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 76,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _currentPage != _numPages - 1 ? true : false,
                        child: FlatButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Siguiente',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10.0),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.orange,
                                size: 30.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomSheet: _currentPage == _numPages - 1
              ? Container(
                  height: 50.0,
                  width: double.infinity,
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.0),
                        child: Text(
                          'Iniciar Registro',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Text(''),
        ),
      ),
    );
  }
}
