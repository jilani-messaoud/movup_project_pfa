

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movup/Screens/signin_screen.dart';
import 'package:movup/Services/storage_services.dart';
import 'package:movup/Utils/color_utils.dart';
import 'package:movup/article_data.dart';
class client_screen extends StatefulWidget {
  const client_screen({Key? key}) : super(key: key);

  @override
  State<client_screen> createState() => _client_screen();
}
class _client_screen extends State<client_screen> {
  final Stream<QuerySnapshot> articles =
      FirebaseFirestore.instance.collection('articles').snapshots();
  CollectionReference commandes =
      FirebaseFirestore.instance.collection("commande");
  /*CollectionReference livreurs =
  FirebaseFirestore.instance.collection("Users");
  CollectionReference vehicule =
  FirebaseFirestore.instance.collection("vehicule");
*/
  final Storage storage = Storage();
  final livreur = [
    'livreur_1_prix_5dt_durée_10j',
    'livreur_2_prix_8dt_durée_7j',
    'livreur_3_prix_10dt_durée_3j'

  ];
   String? liv_value;
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
        child: StreamBuilder<QuerySnapshot>(
          stream: articles,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("something wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading wait few instance");
            }

            final datauser = snapshot.requireData;
            return ListView.builder(
              itemCount: snapshot.requireData.size,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Text("Nom d'article", style: TextStyle(color: Colors.black54,fontSize: 18)),
                      Text(datauser.docs[index]["Nom"].toString()),
                      Text("Reference d'article", style: TextStyle(color: Colors.black54,fontSize: 18)),
                      Text(datauser.docs[index]["Reference"].toString()),
                      Text("Vendeur d'article", style: TextStyle(color: Colors.black54,fontSize: 18)),
                      Text(datauser.docs[index]["Vendeur_id"].toString()),
                      Text("categorie  d'article", style: TextStyle(color: Colors.black54,fontSize: 18)),
                      Text(datauser.docs[index]["categorie"].toString()),
                      Text("quantoite d'article", style: TextStyle(color: Colors.black54,fontSize: 18)),
                      Text(datauser.docs[index]["quantite"].toString()),

                      FutureBuilder(
                          future: storage
                              .downloadURL(datauser.docs[index]["image"]),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Container(
                                  width: 300,
                                  height: 250,
                                  child: Image.network(snapshot.data!,
                                      fit: BoxFit.cover));
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            return Container();
                          }),
                      ElevatedButton(
                          onPressed: () {



                            TextEditingController _quantite =
                                TextEditingController();
                            TextEditingController _ville =
                            TextEditingController();
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(

                                    title: Text("fenetre d'achat"),
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: _quantite,
                                            decoration: InputDecoration(
                                                hintText: 'quantite'),
                                          ),
                                          TextField(
                                            controller: _ville,
                                            decoration: InputDecoration(
                                                hintText: 'ville'),

                                          ),

                                          DropdownButton<String>(
                                            hint: Text("selectionner livreur"),
                                            value: liv_value,
                                            isExpanded: true,
                                            items: livreur.map(buildmenulivreur).toList(),
                                            onChanged: (liv_value) =>
                                                setState(() => this.liv_value = liv_value),
                                          ),

                                        ],
                                      ),
                                    ),
                                    actions: [

                                      FlatButton(
                                        onPressed: () {
                                        /*
                                          livreurs.snapshots().forEach((element_l) {
                                            if(element_l.docs[0]["role"]=="livreur")
                                              {
                                                vehicule.snapshots().forEach((element_v) {
                                                  if(element_l.docs[0]["userid"]==element_v.docs[0]["livreur_id"] &&
                                                  element_l.docs[0]["villes"].toString().contains(_ville.text)&&
                                                      element_l.docs[0]["villes"].toString().contains(datauser.docs[index]["ville"].toString()))
                                                    {
                                                      livreur.add(element_v);
                                                    }
                                                });
                                              }
                                          });
                                            */
                                          commandes.add({
                                            'Article_ref': datauser.docs[index]
                                                    ["Reference"]
                                                .toString(),
                                            'Article_name': datauser.docs[index]
                                                    ["Nom"]
                                                .toString(),
                                            'Vendeur_id': datauser.docs[index]
                                                    ["Vendeur_id"]
                                                .toString(),
                                            'Client_id': FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString(),
                                            'quantite': int.parse(
                                                _quantite.text.trim()),
                                            'etat' : "en attend",
                                            'livreur' : liv_value,
                                            'ville_depart' : datauser.docs[index]['ville'].toString().trim(),
                                            'ville_arrive' : _ville.text.trim()
                                          });
                                          int qt = int.parse(datauser
                                              .docs[index]["quantite"]
                                              .toString());
                                          final art = FirebaseFirestore.instance
                                              .collection('articles')
                                              .doc(datauser.docs[index].id);
                                          art.update({
                                            'quantite': qt -
                                                int.parse(
                                                    _quantite.text.trim()),
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: Text('Submit'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text("acheter produit"))
                    ],
                  ),
                );
              },
            );

          },
        ),
      ),
    );
  }
  DropdownMenuItem<String> buildmenulivreur(String livreur) =>
      DropdownMenuItem(
        value: livreur,
        child: Text(
          livreur,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
  );


}




