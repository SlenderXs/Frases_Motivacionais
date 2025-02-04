import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart'; // Importa o pacote

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _frase = "Clique abaixo para gerar uma frase! :)";
  final translator = GoogleTranslator(); // Instancia do tradutor

  Future<void> fetchQuote() async {
    try {
      final response =
          await http.get(Uri.parse("https://zenquotes.io/api/random"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        String fraseEmIngles = data[0]["q"]; // Frase original em inglês

        // Traduz para português
        Translation translation =
            await translator.translate(fraseEmIngles, from: 'en', to: 'pt');

        setState(() {
          _frase = translation.text;
        });
      } else {
        setState(() {
          _frase = "Erro ao carregar frase. Código: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _frase = "Erro de conexão: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Frases do dia"),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("Images/logo.png"),
              Text(
                _frase,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87),
              ),
              ElevatedButton(
                onPressed: fetchQuote,
                child: Text(
                  "Nova Frase",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
