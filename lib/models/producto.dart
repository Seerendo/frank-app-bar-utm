class Producto{
  int id;
  String nombre;
  String puedeBorrar;

  Producto({this.id, this.nombre, this.puedeBorrar});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      puedeBorrar: json['puede_borrar']
    );
  }
}