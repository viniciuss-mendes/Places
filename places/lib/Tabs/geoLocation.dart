import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/Tabs/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:places/Tabs/savePlace.dart';

class geoLocation extends StatefulWidget {
  static String tag = '/geoLocation';
  String colecao;
  geoLocation(this.colecao);
  @override
  _geoLocationState createState() => _geoLocationState();
}

class _geoLocationState extends State<geoLocation> {
  GoogleMapController mapController;
  var latitude = 0.0.abs();
  var longitude = 0.0.abs();
  FirebaseFirestore db = FirebaseFirestore.instance;
 var salvarController = TextEditingController();


  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude = posicao.latitude;
      longitude = posicao.longitude;
      mapController.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    } catch (e) {
     SnackBar(
        content: Text("Erro"),
        backgroundColor: Colors.grey[900],
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text("Maps Location"),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => Home(widget.colecao)
                ),);},
                child: Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 26.0,
                ),
          ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      final posicao = await _posicaoAtual();
                      latitude = posicao.latitude;
                      longitude = posicao.longitude;
                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => savePlace(widget.colecao, latitude, longitude)
                          ),);},
                    child: Icon(
                          Icons.save_alt,  // add custom icons also
                    ),
                  )
              ),
            ],
    ),
      body:GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 11.0,
        ),
        myLocationEnabled: true,
      ),
    );
  }
}

