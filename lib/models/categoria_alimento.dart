class CategoriaAlimento {
  int id;
  String nombre;

  CategoriaAlimento({this.id, this.nombre});

  factory CategoriaAlimento.fromJson(Map<String, dynamic> json) {
    return CategoriaAlimento(
      id: json['id'],
      nombre: json['nombre']
    );
  }
}