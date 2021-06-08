import 'package:flutter/material.dart';
import 'package:places/Tabs/login.dart';

class Introduction extends StatefulWidget {
  static String tag = '/introduction';
  Introduction();
  @override
  _introductionState createState() => _introductionState();
}

class _introductionState extends State<Introduction>{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Places"),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => Introduction(),
                ),);},
            child: Icon(
              Icons.arrow_back_ios_outlined,
              size: 26.0,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 40,),
              Text("Getting my Places", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, backgroundColor: Colors.white12)),
              SizedBox(height: 150,),
              FlatButton(
                child: Text("Go to Login Now", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  height: 60,
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => login(),
                      ),
                    );
                  },
                color: Colors.teal,
                  )
            ],
          ),
        ),
      );
  }
}
