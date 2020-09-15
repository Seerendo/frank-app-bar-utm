import 'package:cfhc/models/menu_diario.dart';
import 'package:cfhc/models/producto_bar.dart';

class ProductoPedido {
  int id;
  int id_bar;
  String nombre;
  double precio;
  int cantidad;

  ProductoPedido ({this.id, this.id_bar, this.nombre, this.precio, this.cantidad});

  factory ProductoPedido .fromProductoBar(ProductoBar prod) {
    return ProductoPedido (
      id: prod.id,
      id_bar: prod.id_bar,
      nombre: prod.nombre,
      precio: prod.precio,
      cantidad: 1
    );
  }

  factory ProductoPedido .fromMenuDiario(MenuDiario prod) {
    return ProductoPedido (
      id: prod.id_producto,
      id_bar: prod.id_bar,
      nombre: prod.nombre,
      precio: prod.precio,
      cantidad: 1
    );
  }
}