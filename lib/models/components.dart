class Components{
  int id;
  String nombre;

  Components({this.id, this.nombre});

  factory Components.fromJson(Map<String, dynamic> json) {
    return Components(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}