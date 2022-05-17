import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movup/Screens/Livrer_screen.dart';
import 'package:movup/Screens/signin_screen.dart';
import 'package:movup/Services/storage_services.dart';
import 'package:movup/Utils/color_utils.dart';
import 'package:movup/reusable_widgets/reusable_widget.dart';

class add_vehicull extends StatelessWidget {
  CollectionReference vehicule =
  FirebaseFirestore.instance.collection("vehicule");
  final Storage storage = Storage();

  TextEditingController _listville = TextEditingController();
  TextEditingController _immatricule = TextEditingController();
  TextEditingController _duree = TextEditingController();
  TextEditingController _prix = TextEditingController();
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
      Text("entrer la liste de ville visite"),
      reusableTextField("liste ville", Icons.format_color_text, false, _listville),
      const SizedBox(
        height: 20,
      ),
      Text("entrer l'immatricule de vehicule"),
      reusableTextField("immatricule", Icons.format_color_text, false, _immatricule),
      const SizedBox(
        height: 20,
      ),
      Text("entrer la duree d'attends de livraison en jour"),
      reusableTextField("duree", Icons.format_color_text, false, _duree),
      const SizedBox(
        height: 20,
      ),
      Text("entrer le prix de livraison"),
      reusableTextField("prix", Icons.format_color_text, false, _prix),
      ElevatedButton(
          onPressed: () {
            vehicule
                .add({
              "livreur_id": FirebaseAuth.instance.currentUser!.uid
                  .toString()
                  .trim(),
              "immatricule": _immatricule.text.trim(),
              "villes": _listville.text.trim(),
              "duree": int.parse(_duree.text.trim()),
              "prix": int.parse(_prix.text.trim())

            })
                .then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        livreur_screen())))
                .onError((error, stackTrace) {
              print("Error ${error.toString()}");
            });
          },
          child: Text("ajouter l'article")),

      ]
    ),
    ),
    ),
        ),
    );
  }
}
