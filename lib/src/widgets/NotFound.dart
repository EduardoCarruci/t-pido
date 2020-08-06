
import 'package:flutter/material.dart';
import 'package:t_pido/src/utils/const.dart';

class NotFound extends StatelessWidget {
  NotFound({
    @required this.texto,
  });

  final String texto;

 //"No hay Rubros.."
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
     
    SizedBox(
    height: 20.0,
    ),
    Text(texto, style: Utils.textBlueShade900),
      ],
    );
  }
}