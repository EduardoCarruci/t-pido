import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/screens/Login.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 't-pido',
        initialRoute: 'Login',

        //MAPA DE RUTAS
        routes: {
          'Login': (BuildContext context) => Login(),
        });
  }
}
