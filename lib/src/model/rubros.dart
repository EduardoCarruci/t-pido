import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

class Rubros {
  String uid;
  String nombre;
  String rubro1;
  String rubro2;
  String rubro3;
  String rubro4;
  String rubro5;
  String rubro6;

   Rubros({
        this.rubro1,
        this.rubro2,
        this.rubro3,
        this.rubro4,
        this.rubro5,
        this.rubro6,
    });

 factory Rubros.fromJson(String str) => Rubros.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());
      Map<String, dynamic> toMap() => {
        "rubro1": rubro1,
        "rubro2": rubro2,
        "rubro3": rubro3,
        "rubro4": rubro4,
        "rubro5": rubro5,
        "rubro6": rubro6,
    };

    factory Rubros.fromMap(Map<String, dynamic> json) => Rubros(
    
        rubro1: json["rubro1"],
        rubro2: json["rubro2"],
        rubro3: json["rubro3"],
        rubro4: json["rubro4"],
        rubro5: json["rubro5"],
        rubro6: json["rubro6"],
    );

  
  Rubros.fromFireStore(DocumentSnapshot document)
      : uid = document.documentID,
        nombre = document.data['nombre'];
        



}

List<Rubros> toRubrosList(QuerySnapshot query) {
  return query.documents.map((doc) => Rubros.fromFireStore(doc)).toList();
}
