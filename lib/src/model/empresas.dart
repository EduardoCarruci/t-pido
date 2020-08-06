import 'package:cloud_firestore/cloud_firestore.dart';

class Empresas {
  String uid;
  String codigo;
  String nombre;
  List<String> rubros;
  String linkform;
  //NUEVA DATA
  String coordenadax;
  String coordenaday;
  String direccion;
  String distrito;
  String email;
  String lnombre;
  String telefono;

  Empresas({
    this.linkform,
    this.coordenadax,
    this.coordenaday,
    this.direccion,
    this.distrito,
    this.email,
    this.lnombre,
    this.telefono,
  });

  Empresas.fromFireStore(DocumentSnapshot document)
      : uid = document.documentID,
        codigo = document.data['codigo'],
        nombre = document.data['nombre'],
        rubros = List.from(document.data['rubro']),
        linkform = document.data['linkform'],
        coordenadax = document.data['LcoordenadaX'],
        coordenaday = document.data['LcoordenadaY'],
        direccion = document.data['Ldireccion'],
        distrito = document.data['Ldistrito'],
        email = document.data['Lemail'],
        lnombre = document.data['Lnombre'],
        telefono = document.data['Ltelefono'];
}

List<Empresas> toEmpresasList(QuerySnapshot query) {
  return query.documents.map((doc) => Empresas.fromFireStore(doc)).toList();
}


  Future<List<Empresas>> getUserTaskList(String query) async {
    QuerySnapshot qShot = await Firestore.instance
        .collection('empresas')
        .where("nombre", isEqualTo: query)
        .getDocuments();
    print(qShot);
    return qShot.documents
        .map((document) => Empresas(
            linkform: document.data['linkform'],
            coordenadax: document.data['LcoordenadaX'],
            coordenaday: document.data['LcoordenadaY'],
            direccion: document.data['Ldireccion'],
            distrito: document.data['Ldistrito'],
            email: document.data['Lemail'],
            lnombre: document.data['Lnombre'],
            telefono: document.data['Ltelefono']))
        .toList();
  }