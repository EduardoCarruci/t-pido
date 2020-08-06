import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Documento {
  String uid;

  String politicas;
  String terminos;

  Documento({
    this.uid,
    this.politicas,
    this.terminos,
  });

  Documento.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        politicas = snapshot['politicas'],
        terminos = snapshot['terminos'];
}

List<Documento> toUserList(QuerySnapshot query) {
  return query.documents.map((doc) => Documento.fromSnapshot(doc)).toList();
}
