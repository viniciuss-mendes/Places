import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:places/Tabs/geoLocation.dart';
import 'package:http/http.dart' as http;
import 'package:places/Tabs/home_page.dart';

class savePlace extends StatefulWidget {
  static String tag = '/geoLocation';
  String colecao;
  var latitude;
  var longitude;
  savePlace(this.colecao, this.latitude, this.longitude);
  @override
  _savePlaceState createState() => _savePlaceState();
}

class _savePlaceState extends State<savePlace> {

  var nomeController = TextEditingController();
  var latitudeController = TextEditingController();
  var longitudeController = TextEditingController();
  var CEPController = TextEditingController();
  var complementoController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  String _resultado = "";
  String resultadoSalvar;
  _recuperaCep() async {
    String cepDigitado = CEPController.text;
    var uri = Uri.parse("https://viacep.com.br/ws/${cepDigitado}/json/");
    http.Response response;
    response = await http.get(uri);
    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];
    String uf = retorno["uf"];
    String ddd = retorno["ddd"];
    setState(() { //configurar o _resultado
      _resultado =
      "\n\nDDD: ${ddd} \n\nUF: ${uf} \n\nLocalidade: ${localidade} \n\nBairro: ${bairro} \n\nLogradouro: ${logradouro} \n\nComplemento: ${complemento} ";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Salvar local atual"),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => geoLocation(widget.colecao)
              ),);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            size: 26.0,
          ),
        ),
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Nome do local:",
                    hintText: "Informe o nome do local você está atualmente"
                ),
                controller: nomeController
            ),
            SizedBox(height: 20,),
            TextFormField(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Informe CEP (Opcional)",
                    hintText: "Informe o CEP do local que deseja salvar"
                ),
                controller: CEPController
            ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              color: Colors.white60,
              child: ElevatedButton(
                  child: Text('Pesquisar Endereço',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white),),
                  onPressed: () async {
                    _recuperaCep();
                  }
              ),
            ),
            SizedBox(height: 10,),
            Text(_resultado),
            SizedBox(height: 20,),
            TextFormField(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Informe um complemento (Opcional)",
                    hintText: "Informe um complemento para agregar ao endereço pesquisado"
                ),
                controller: complementoController
            ),
            SizedBox(height: 50,),
            Container(
              height: 40,
              child: ElevatedButton(
                  child: Text("Adicionar Local",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                    ),),
                  onPressed: () async {
                    resultadoSalvar = _resultado + complementoController.text;
                    await db.collection(widget.colecao)
                        .doc(nomeController.text)
                        .set
                      ({
                      'nome': nomeController.text,
                      'CEP': CEPController.text,
                      'endereco': resultadoSalvar,
                      'latitude': widget.latitude.toString(),
                      'longitude': widget.longitude.toString(),
                      'excluido': false,
                      'foto': "https://i.pinimg.com/736x/f1/50/1d/f1501debe74eb0fe4807667cc541c86a.jpg"
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(widget.colecao),
                      ),
                    );
                  }
              ),
            ),
            SizedBox(height: 30,),
            Container(
              height: 40,
              child: ElevatedButton(
                  child: Text("Cancelar",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                    ),),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => geoLocation(widget.colecao),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}