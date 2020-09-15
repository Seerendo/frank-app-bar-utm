class MenuDiario {
  int id;
  int id_producto;
  int id_bar;
  String nombre;
  double precio;

  MenuDiario ({this.id, this.id_producto, this.id_bar, this.nombre, this.precio});

  factory MenuDiario .fromJson(Map<String, dynamic> json) {
    return MenuDiario (
      id: json['id_menu_diario'],
      id_producto: json['id_producto'],
      id_bar: json['id_bar'],
      nombre: json['nombre'],
      precio: double.parse(json['precio'].toString())
    );
  }
}