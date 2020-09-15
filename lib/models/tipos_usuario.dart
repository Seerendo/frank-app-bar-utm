class TipoUsuario{
  int id;
  String nombre;

  TipoUsuario({this.id, this.nombre});

  factory TipoUsuario.fromJson(Map<String, dynamic> json) {
    return TipoUsuario(
      id: json['id'],
      nombre: json['nombre']
    );
  }
}