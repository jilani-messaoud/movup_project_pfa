import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movup/Screens/signin_screen.dart';
import 'package:movup/Services/storage_services.dart';
import 'package:movup/Utils/color_utils.dart';

class commande_livreur extends StatelessWidget {

  final Stream<QuerySnapshot> commandes =
  FirebaseFirestore.instance.collection('commande').snapshots();
  final Storage storage = Storage();
  CollectionReference ref = FirebaseFirestore.instance.collection('commande');

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
            stream: ref.snapshots(),
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
                  if (datauser.docs[index]["livreur_id"].toString() !=
                      FirebaseAuth.instance.currentUser!.uid.toString()) {
                    return Text("");
                  } else {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                      child: Column(
                        children: <Widget>[
                          Text("ville depart", style: TextStyle(color: Colors.black54,fontSize: 18)),
                          Text(datauser.docs[index]["ville depart"].toString()),
                          Text("ville de retour", style: TextStyle(color: Colors.black54,fontSize: 18)),
                          Text(datauser.docs[index]["ville de retour"].toString()),
                          Text("categorie d'article", style: TextStyle(color: Colors.black54,fontSize: 18)),
                          Text(datauser.docs[index]["Article_ref"].toString()),
                          Text("quantite d'article", style: TextStyle(color: Colors.black54,fontSize: 18)),
                          Text(datauser.docs[index]["Article_name"].toString()),
                          Text("client id", style: TextStyle(color: Colors.black54,fontSize: 18)),
                          Text(datauser.docs[index]["Client_id"].toString()),
                          Text("vendeur id", style: TextStyle(color: Colors.black54,fontSize: 18)),
                          Text(datauser.docs[index]["Vendeur_id"].toString()),
                          Text("quantite", style: TextStyle(color: Colors.black54,fontSize: 18)),
                          Text(datauser.docs[index]["quantite"].toString()),
                          ElevatedButton(
                              onPressed: () {
                                final cmd = FirebaseFirestore.instance
                                    .collection('commande')
                                    .doc(datauser.docs[index].id);
                                cmd.update({
                                  'etat': "reçu",
                                });
                              },
                              child: Text("livraison terminer"))
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
    );
  }
}
