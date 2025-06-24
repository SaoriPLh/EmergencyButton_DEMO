class Addcontactrequest {
  final String nombre;
  final String numero;

  Addcontactrequest({
    required this.nombre,
    required this.numero,
  });

  Map<String, dynamic> toJson() {
    return {
        
      'nombre': nombre,
      
      'numero': numero,
      
    };
  }
}
