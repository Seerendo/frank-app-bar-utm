class ProductoBar {
  int id;
  int id_bar;
  String nombre;
  double precio;

  ProductoBar ({this.id, this.id_bar, this.nombre, this.precio});

  factory ProductoBar .fromJson(Map<String, dynamic> json) {
    return ProductoBar (
      id: json['id_producto'],
      id_bar: json['id_bar'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString())
    );
  }
}