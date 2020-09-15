import 'package:cfhc/models/categoria_alimento.dart';

class Preferencia {
  int id_categoria_alimento;
  int id_usuario;
  String nombre;
  int valor;

  Preferencia({
    this.id_categoria_alimento,
    this.id_usuario,
    this.nombre,
    this.valor
  });

  factory Preferencia.fromJson(Map<String, dynamic> json) {
    return Preferencia(
      id_categoria_alimento: json['id_categoria_alimento'],
      id_usuario: json['id_usuario'],
      nombre: json['nombre'],
      valor: json['valor']
    );
  }
}