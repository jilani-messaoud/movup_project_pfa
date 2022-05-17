import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movup/Screens/AddVehicule.dart';
import 'package:movup/Screens/commande_livreur.dart';
import 'package:movup/Screens/signin_screen.dart';
import 'package:movup/Utils/color_utils.dart';

class livreur_screen extends StatelessWidget {
  const livreur_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
        actions: [
          new IconButton(onPressed:(){
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()) );
            });

          }
              , icon: Icon(Icons.vpn_key)


          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("F39C12"),
              hexStringToColor("FFD07E"),
              hexStringToColor("F1C40F")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[

                const SizedBox(
                height: 20,
              ),
              Text("add vehicule"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add_vehicull()));
                  },
                  child: Text('ajoute vehicule article')),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("show comande"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => commande_livreur()));
                      },
                      child: Text('show comande')),

                ],
              ),
            ),
          ),



      ),
    );
  }
}
