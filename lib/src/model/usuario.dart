import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Usuario {
  String uid;
  int id;
  String nombre;
  String telefono;
  String direccion;
  String distrito;
  String email;
  String coordenadasX;
  String coordenadasY;
  List<String> empresa;
  String empresa1;
  String empresa2;
  String empresa3;
  String empresa4;
  String empresa5;
  String empresa6;
  String empresa7;
  String empresa8;
  String empresa9;
  String empresa10;

  Usuario({
    this.id,
    this.email,
    this.empresa1,
    this.empresa2,
    this.empresa3,
    this.empresa4,
    this.empresa5,
    this.empresa6,
    this.empresa7,
    this.empresa8,
    this.empresa9,
    this.empresa10,
  });
  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "empresa1": empresa1,
        "empresa2": empresa2,
        "empresa3": empresa3,
        "empresa4": empresa4,
        "empresa5": empresa5,
        "empresa6": empresa6,
        "empresa7": empresa7,
        "empresa8": empresa8,
        "empresa9": empresa9,
        "empresa10": empresa10,
      };
  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  factory Usuario.fromMap(Map<String, dynamic> json) => new Usuario(
      id: json["id"],
      email: json["email"],
      empresa1: json["empresa1"],
      empresa2: json["empresa2"],
      empresa3: json["empresa3"],
      empresa4: json["empresa4"],
      empresa5: json["empresa5"],
      empresa6: json["empresa6"],
      empresa7: json["empresa7"],
      empresa8: json["empresa8"],
      empresa9: json["empresa9"],
      empresa10: json["empresa10"]);

  Usuario.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        nombre = snapshot['nombre'],
        telefono = snapshot['telefono'],
        direccion = snapshot['direccion'],
        distrito = snapshot['distrito'],
        email = snapshot['email'],
        coordenadasX = snapshot['coordenadasX'],
        coordenadasY = snapshot['coordenadasY'],
        empresa = List.from(snapshot.data['empresas']);
}

List<Usuario> toUserList(QuerySnapshot query) {
  return query.documents.map((doc) => Usuario.fromSnapshot(doc)).toList();

}