class Ingredientes{
  int idproducto;
  int idcomponente;
  String producto;
  String componente;
  String nombre;
  int id;

  Ingredientes({this.id, this.nombre});

  factory Ingredientes.fromJson(Map<String, dynamic> json) {
    return Ingredientes(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}