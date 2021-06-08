import 'package:places/Tabs/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class add extends StatefulWidget {
  static String tag = '/add';
  String nome;
  add(this.nome);
  @override
  _addState createState() => _addState();
}

class _addState extends State<add> {
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
      _resultado = "\n\nDDD: ${ddd} \n\nUF: ${uf} \n\nLocalidade: ${localidade} \n\nBairro: ${bairro} \n\nLogradouro: ${logradouro} \n\nComplemento: ${complemento} ";
    });
  }
  var nomeController = TextEditingController();
  var latitudeController = TextEditingController();
  var longitudeController = TextEditingController();
  var CEPController = TextEditingController();
  var complementoController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Salvar Locais"),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => Home(widget.nome)
              ),);},
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
                    hintText: "Informe o nome do local que deseja salvar"
                ),
                controller: nomeController
            ),
            SizedBox(height: 15,),
            TextFormField(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Informe a latitude(opcional)",
                    hintText: "Informe a latitude do local "
                ),
                controller: latitudeController
            ),
            SizedBox(height: 15,),
            TextFormField(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Informe a longitude(opcional)",
                    hintText: "Informe a longitude do local "
                ),
                controller: longitudeController
            ),
            SizedBox(height: 15,),
            TextFormField(
                style: TextStyle(
                   fontSize: 12,
                   color: Colors.black,
                 ),
                 decoration: InputDecoration(
                     labelText: "Informe CEP",
                     hintText: "Informe o CEP do local que deseja salvar"
                 ),
                 controller: CEPController
             ),
            SizedBox(height: 20,),
            Container(
              height: 40,
              color: Colors.white60,
              child:  ElevatedButton(
                 child: Text('Pesquisar Endereço',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white),),
                  onPressed: () async{
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
                    labelText: "Informe um complemento",
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
                    await db.collection(widget.nome).doc(nomeController.text).set
                      ({'nome' : nomeController.text,
                      'CEP' : CEPController.text,
                      'endereco' : resultadoSalvar,
                      'latitude' : latitudeController.text,
                      'longitude' : longitudeController.text,
                      'excluido': false,
                      'foto' : "https://i.pinimg.com/736x/f1/50/1d/f1501debe74eb0fe4807667cc541c86a.jpg"});
                    Navigator.of(context).pop();
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
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(widget.nome),
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