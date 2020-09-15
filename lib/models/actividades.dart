class Actividad {
  int id;
  String nombre;

  Actividad({this.id, this.nombre});

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id'],
      nombre: json['nombre']
    );
  }
}