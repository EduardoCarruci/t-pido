import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_pido/src/model/empresas.dart';
import 'package:t_pido/src/model/rubros.dart';
// SOLICITAR TODOS LOS RUBROS Y AL MISMO TIEMPO PARSEARLOS A UNA LISTA DEl MODELO DE RUBROS
Stream<List<Rubros>> getRubros() {
  return Firestore.instance.collection('rubros').snapshots().map(toRubrosList);
}

// SOLICITAR TODOS LAS EMPRESAS Y AL MISMO TIEMPO PARSEARLOS A UNA LISTA DEl MODELO DE EMPRESAS
Stream<List<Empresas>> getEmpresas(String query) {
  return Firestore.instance
      .collection('empresas')
      .where("rubro", arrayContains: query)
      .snapshots()
      .map(toEmpresasList);
}
// OBTENER LA EMPRESA SE PARSEA LA CADENA A MINUSULA
Stream<List<Empresas>> getUniqueEmpresas(String query) {
  return Firestore.instance
      .collection('empresas')
      .where("busqueda", arrayContains: query.toLowerCase())
      .snapshots()
      .map(toEmpresasList);
}
