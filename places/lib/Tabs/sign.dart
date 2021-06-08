import 'package:flutter/material.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '';

class sign extends StatefulWidget {
  static String tag = '/sign';
  @override
  _signState createState() => _signState();
}

class _signState extends State<sign> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cadastro"),
        leading: GestureDetector(
          onTap: () { Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => login()
            ),); },
          child: Icon(
            Icons.arrow_back_ios_outlined,  // add custom icons also
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            SizedBox(height: 50,),
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Login:",
                  hintText: "Digite o login"
              ),
              controller: _controllerLogin,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite o texto";
                }
                return null;
              },
            ),
            SizedBox(height: 30,),
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Senha:",
                  hintText: "Digite a senha"
              ),
              obscureText: true,
              controller: _controllerSenha,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite a senha ";
                }
                if(text.length < 4){
                  return "A senha tem pelo menos 4 dígitos";
                }
                return null;
              },
            ),
            SizedBox(height: 60,),

            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Cadastro",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),),
                  onPressed: () async {
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }
                    else{
                      await db.collection(_controllerLogin.text).add({
                        'usuario': _controllerLogin.text,
                        'senha':_controllerSenha.text
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => login()
                        ),
                      );
                    }
                    print("Login "+_controllerLogin.text);
                    print("Senha "+_controllerSenha.text);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
