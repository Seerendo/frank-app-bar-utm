class Enfermedad{
  int id;
  String nombre;

  Enfermedad({this.id, this.nombre});

  factory Enfermedad.fromJson(Map<String, dynamic> json) {
    return Enfermedad(
      id: json['id'],
      nombre: json['nombre']
    );
  }

  factory Enfermedad.fromUsuarioEnfermedadJson(Map<String, dynamic> json) {
    return Enfermedad(
      id: json['id_enfermedad'],
      nombre: json['nombre']
    );
  }
}