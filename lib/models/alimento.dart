class Alimento {
  int id;
  String nombre;

  Alimento({this.id, this.nombre});

  factory Alimento.fromJson(Map<String, dynamic> json) {
    return Alimento(
      id: json['id'],
      nombre: json['nombre']
    );
  }
}