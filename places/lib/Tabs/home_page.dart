import 'package:places/Tabs/add.dart';
import 'package:places/Tabs/geoLocation.dart';
import 'package:places/Tabs/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  static String tag = '/home';
  String nome;
  Home(this.nome);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var snap = db.collection(widget.nome).where('excluido', isEqualTo: false).snapshots();

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Places"),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => login()
                ),); },
              child: Icon(
                Icons.exit_to_app,
                size: 26.0,
              ),

            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => geoLocation(widget.nome)
                      ),);},
                    child: Icon(
                      Icons.add_location_alt_outlined,
                      size: 26.0,
                    ),
                  )
              ),
            ]
        ),

        body: StreamBuilder(
          stream: snap,
          builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot
              ) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, i){
                var item = snapshot.data.docs[i];
                return Dismissible(
                    key: Key(item.id),
                    onDismissed: (direction) {
                      setState(() async {
                        await db.collection(widget.nome).doc(item.id).delete();
                      });
                      },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white)
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: NetworkImage(item['foto']),

                      ),
                      title: Text(item['nome']),
                      subtitle: Text(item['CEP']),
                      trailing: TextButton.icon(
                        icon: Icon(Icons.pages, size: 18, color: Colors.black38),
                        label: Text(''),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                backgroundColor: Colors.lightGreen,
                                title: new Text("Local Salvo", style: TextStyle(color: Colors.teal, backgroundColor: Colors.white12), textAlign: TextAlign.center,),
                                actions: <Widget>[
                                  SizedBox(height: 10,),
                                  Text("Localização salva:      " + item['nome'], textAlign: TextAlign.center),
                                  SizedBox(height: 10,),
                                  Text("CEP:     " + item['CEP'], textAlign: TextAlign.left),
                                  SizedBox(height: 10,),
                                  Text("Endereço: " + item['endereco']),
                                  SizedBox(height: 10,),
                                  Text("Latitude:      " + item['latitude'], textAlign: TextAlign.left),
                                  SizedBox(height: 10,),
                                  Text("Longitude:      " + item['longitude'], textAlign: TextAlign.left),

                                  FlatButton(
                                    child: Text("Fechar", style: TextStyle(color: Colors.teal),),
                                    onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  )
                                ],
                              ));

                        }
                        ),
                      ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => add(widget.nome)
              ),
            );
          },
          tooltip: "Adicionar novo",
          child: Icon(Icons.add),
        ),
      );
    }  // build
  }