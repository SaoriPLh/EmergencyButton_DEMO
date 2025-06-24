import 'dart:convert';

import 'package:emergency_button/data/http/apiService.dart';
import 'package:emergency_button/data/http/httpClient.dart';
import 'package:emergency_button/data/repositoris/contact_repo.dart';
import 'package:emergency_button/data/repositoris/personalData_repo.dart';
import 'package:emergency_button/data/services/contactService.dart';
import 'package:emergency_button/data/services/personalDataService.dart';
import 'package:emergency_button/presentation/add_contactScreen.dart';
import 'package:emergency_button/presentation/personal_dataScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Homescrenbutton extends StatefulWidget{
  final String nombre;
  final String direccion;

  Homescrenbutton(this.nombre, this.direccion);
  @override
  _HomeScreenButtonState createState() =>  _HomeScreenButtonState();



}

class _HomeScreenButtonState extends State<Homescrenbutton>{
 
   //empezamos a cargar las cosas cuando comience la aplicacion
late ContactService contactService;  //que es late? 
  late PersonalDataService personalDataService;
   @override
  void initState(){
    
    super.initState();
    final apiService = ApiService(httpClient: HttpclientService()); 
    contactService = ContactService(contactRepo: ContactRepo(apiService: apiService));
    personalDataService = PersonalDataService(personaldataRepo: PersonaldataRepo(apiService: apiService));

  }
 //este metodo lo que hara es cargar los contactos e informacion y mandarla al backend
 Future<void> _handleEmergency() async {
  try {
    final contacts = await contactService.loadContacts();
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No hay contactos guardados."),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    final personalData = await personalDataService.load();
    final name = personalData.NombreCompleto;

    final locationResponse = await http.get(
      Uri.parse('http://192.168.100.13:3002/getCurrentLocation'),
    );

    //  Verificamos si fue exitoso y si es JSON válido
    if (locationResponse.statusCode != 200) {
      throw Exception("Servidor no respondió con éxito (código: ${locationResponse.statusCode})");
    }

    //  Intentamos convertir el JSON
    late Map<String, dynamic> location;

final body = locationResponse.body.trim();
if (body.isEmpty || (!body.startsWith('{') && !body.startsWith('['))) {
  throw Exception("El servidor de ubicación devolvió una respuesta vacía o no válida.");
}

try {
  location = jsonDecode(body);
} catch (e) {
  throw Exception("Error al interpretar la ubicación: ${e.toString()}");
}


    final lat = location['lat'].toString();
    final lon = location['lon'].toString();

    final response = await http.post(
      Uri.parse('http://192.168.100.13:3002/sendSMS'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'lat': lat, 'lon': lon}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Mensaje de emergencia enviado exitosamente"),
        backgroundColor: Colors.green,
      ));
    } else {
      throw Exception("Error al enviar mensaje de emergencia");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(" ${e.toString()}"),
      backgroundColor: Colors.red,
    ));
  }
}


  double _scale = 1.0;

  void _animateTap() {
    setState(() => _scale = 1.4);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() => _scale = 1.0);
    });
  }

  //aca vamos a importar servicios como el del boton y navegaciones a las demas pantallas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: 
        AppBar(
        iconTheme: IconThemeData(size: 30),  //general para el tamaño de los iconos
        title: Center(
          child: Text("S O S"),
        ),
        
        leading: 
        Padding(  
          //metemos los iconos en padding 
          padding: EdgeInsets.all(12),
          child: IconButton(
            onPressed: (){
              //navegar a otra pantalla
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalDataForm(),
              ),
            );

          }, icon: Icon(Icons.note_add)),    //note.add
        ),
        actions: [
         Padding(
      padding: EdgeInsets.all(13),
      child: IconButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddContactscreen(),)),
        icon: Icon(Icons.contacts)),
    ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
            child: Container(
              width: 330,
              height: 110,
              padding: EdgeInsets.all(12), //  Espacio interno para que respire los elementos dentro del container
              decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 194, 194),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
              ),
              child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
            SizedBox(width: 15), //  Separación entre imagen y textos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 widget.nombre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.direccion,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
              ),
            ),
            
          ),
          SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top:40),
            child: Container(
              
              decoration: BoxDecoration(
                
              ),
              child: Column(
                children: [
                  Text(
                  "Are you in Emergency?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Please press the button",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),
                ],
              ),
            ),
          ),
          SizedBox(height: 100), // Espacio entre el texto y el botón
            AnimatedScale(
            scale: _scale,
            duration: Duration(milliseconds: 500),
            child: InkResponse(
              onTap: () {
                _animateTap();
                _handleEmergency();
                print("SOS activado");
              },
              highlightShape: BoxShape.circle,
              splashColor: Colors.white30,
              radius: 140, // hasta dónde se expande el splash
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 247, 44, 44),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "SOS",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
         ],
         
               
      ),
      

    );
  }
}

