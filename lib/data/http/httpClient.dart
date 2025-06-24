import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpclientService {
  final String _baseUrl = 'http://192.168.100.13:3002'; // base url global
  final http.Client _client;

  HttpclientService({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');  //interpreta el texto que tú le das como una URL válida
    return await _client.get(uri, headers: {
      'Content-Type': 'application/json',
  
    });
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    return await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',

      },
      body: body != null ? jsonEncode(body) : null,
    );
  }

  //siempre esperamos un http response

  //asincrono porque es una solicitud http y puede tardar
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async{
    
    final uri = Uri.parse("$_baseUrl$endpoint");
    return await _client.put(  //organizamos la solicutud si hay headers etc ponemos la url final
      uri,
      headers: {
        'Content-Type': 'application/json',

      },
      body: body != null ? jsonEncode(body) : null,
    );

  }


}
