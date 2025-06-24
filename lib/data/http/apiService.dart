import 'dart:convert';
import 'package:emergency_button/data/http/httpClient.dart';


class ApiService {
  final HttpclientService httpClient;

  ApiService({required this.httpClient});

 Future<dynamic> get(String endpoint) async {
  final response = await httpClient.get(endpoint);
  final responseBody = await response.body;

  try {
    final data = jsonDecode(responseBody);

    // Validamos si la respuesta es JSON válido (mapa o lista)
    if (data is Map<String, dynamic> || data is List<dynamic>) {
      return data;
    } else {
      throw Exception("Respuesta JSON inesperada");
    }
  } catch (e) {
    throw Exception("Error al decodificar JSON: $e");
  }
}

Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
  final response = await httpClient.post(endpoint, body);
  final responseBody = await response.body;

  try {
    final data = jsonDecode(responseBody);

    if (data is Map<String, dynamic> || data is List<dynamic>) {
      return data;
    } else {
      throw Exception("Respuesta JSON inesperada");
    }
  } catch (e) {
    throw Exception("Error al decodificar JSON: $e");
  }
}


  
}
