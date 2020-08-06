import 'package:flutter/material.dart';
import 'package:t_pido/src/utils/const.dart';

class ContainerText extends StatelessWidget {
   ContainerText({
    @required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: Utils.mediumBlue,)),
        alignment: Alignment.center,
        child: Text(
          "¿Qué deseas pedir hoy?",
          style: TextStyle(
              color:Utils.mediumBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ));
  }
}
