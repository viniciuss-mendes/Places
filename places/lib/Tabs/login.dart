import 'package:places/Tabs/Introduction.dart';
import 'package:places/Tabs/add.dart';
import 'package:places/Tabs/sign.dart';
import 'package:flutter/material.dart';
import 'package:places/Tabs/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class login extends StatefulWidget {
  static String tag = '/login';
  String nome = "";
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _validarUsuario(String nome, String senha, BuildContext context) async{
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      var snap = await db.collection(_controllerLogin.text).where('usuario', isEqualTo: _controllerLogin.text).where('senha', isEqualTo: _controllerSenha.text).get();
      setState(() {
          String nome = _controllerLogin.text;
          Navigator.push(context, MaterialPageRoute(builder:(context) => Home(nome)));
      });
      if (snap.size > 0)  {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(nome)
          ),
        );
      }
    } catch(e){

    }
  }

  _erro(){
      Text("",
      style: TextStyle(
          fontSize: 20,
          color: Colors.white
      ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Agenda de Contatos"),
        leading: GestureDetector(
          onTap: () { Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => Introduction()
            ),); },
          child: Icon(
            Icons.arrow_back_ios_outlined,  // add custom icons also
          ),
        ),

      ),
      body: Form( //consegue armazenar o estado dos campos de texto e além disso, fazer a validação
        key: _formKey, //estado do formulário
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            SizedBox(height: 70,),
            TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Login:",
                    hintText: "Informe um user name"
                ),
                controller: _controllerLogin
            ),
            SizedBox(height: 30,),
            TextFormField(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    labelText: "Senha:",
                    hintText: "Informe a senha"
                ),
                obscureText: true,
                controller: _controllerSenha
            ),
            SizedBox(height: 80,),
            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Login",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),),
                  onPressed: (){
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }
                    else{
                      var validarUsuario = _validarUsuario(_controllerLogin.text, _controllerSenha.text, context);
                    }
                    _controllerLogin.clear();
                   _controllerSenha.clear();
                    print("Login "+_controllerLogin.text);
                    print("Senha "+_controllerSenha.text);
                  }
              ),
            ),
            SizedBox(height: 40,),
            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Cadastro",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),),
                  onPressed: (){
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sign()
                        ),
                      );
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
