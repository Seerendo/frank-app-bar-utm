class Usuario{
  int id_usuario;
  int id_tipo_usuario;
  String nombre;
  String tipo;
  String apellidos;
  String cedula;
  String correo;
  String pass;

  Usuario({
    this.id_usuario,
    this.id_tipo_usuario,
    this.nombre,
    this.tipo,
    this.apellidos,
    this.correo,
    this.pass
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id_usuario:  json['id'],
      id_tipo_usuario: json['id_tipo_usuario'],
      tipo:  json['tipo'],
      nombre:  json['nombres'],
      apellidos:  json['apellidos'],
      correo:  json['email'],
      pass:  json['pass'] != null ? json['pass'] : "",
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'id_usuario':  this.id_usuario,
      'id_tipo_usuario':  this.id_tipo_usuario,
      'nombres':  this.nombre,
      'apellidos':  this.apellidos,
      'email':  this.correo,
      'password':  this.pass,
      'c_password':  this.pass
    };

  Map<String, dynamic> toJsonPOST() =>
    {
      'id_tipo_usuario':  this.id_tipo_usuario,
      'nombre':  this.nombre,
      'apellidos':  this.apellidos,
      'correo':  this.correo,
      'pass':  this.pass,
    };
}