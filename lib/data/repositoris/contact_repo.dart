import 'package:emergency_button/data/http/apiService.dart';
import 'package:emergency_button/data/models/Contact_model.dart';
import 'package:emergency_button/data/request/addContactRequest.dart';

class ContactRepo {
  final ApiService apiService;

  ContactRepo({required this.apiService});

  // Guardar un nuevo contacto y devolver la lista actualizada
  Future<List<ContactModel>> saveContact(Addcontactrequest data) async {
    final json = await apiService.post("/savePhoneNumber", data.toJson());

    if (json is List) {
      return json.map((item) => ContactModel.fromJson(item)).toList();
    } else {
      throw Exception("La respuesta no es una lista");
    }
  }

  // Obtener todos los contactos guardados
  Future<List<ContactModel>> loadContacts() async {
    final response = await apiService.get("/getPhoneNumbers");

    if (response is List) {
      return response.map((item) => ContactModel.fromJson(item)).toList();
    } else {
      throw Exception("La respuesta no es una lista");
    }
  }

  // Eliminar un número y devolver la lista actualizada
  Future<List<ContactModel>> deletePhoneNumber(String nombre, String numero) async {
    final response = await apiService.post("/deletePhoneNumber", {
      "nombre": nombre,
      "numero": numero
    });

    if (response is List) {
      return response.map((item) => ContactModel.fromJson(item)).toList();
    } else {
      throw Exception("La respuesta no es una lista");
    }
  }
}
