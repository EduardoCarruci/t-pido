import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:t_pido/src/utils/const.dart';

class CustomFlush {

  void showCustomBar(BuildContext context,String mensaje) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: Duration(milliseconds: 1500),
      title: "Mensaje",
      message: mensaje,
      icon: Icon(
        Icons.announcement,
        size: 28.0,
        color: Utils.mediumBlue,
      ),
    )..show(context);
  }

  
}