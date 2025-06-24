class ContactModel {

  final String numeroDeContacto;
 final String nombre;
  ContactModel({required this.numeroDeContacto, required this.nombre});

  //de json a modelo
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      nombre: json['nombre'],
      numeroDeContacto: json['numero'],
    );
  }
 

  //de modelo a json
  Map<String,dynamic> toJson() => {

   "nombre": numeroDeContacto,
   "numero": numeroDeContacto

  };
}