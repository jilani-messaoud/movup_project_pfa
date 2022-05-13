import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movup/Services/storage_services.dart' as storage;

import 'package:movup/Services/storage_services.dart';
import 'package:movup/Utils/color_utils.dart';
import 'package:movup/article_data.dart';

class vendeur_screen_produit extends StatelessWidget {
  final Stream<QuerySnapshot> articles =
      FirebaseFirestore.instance.collection('articles').snapshots();
  final Storage storage = Storage();
  CollectionReference ref = FirebaseFirestore.instance.collection('articles');
  TextEditingController _quantite = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
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
                if (datauser.docs[index]["Vendeur_id"].toString() !=
                    FirebaseAuth.instance.currentUser!.uid.toString()) {
                  return Text("");
                } else {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(
                      children: <Widget>[
                        Text(datauser.docs[index]["Nom"].toString()),
                        Text(datauser.docs[index]["Reference"].toString()),
                        Text(datauser.docs[index]["categorie"].toString()),
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
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Edit User Details'),
                                      content: Container(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: _quantite,
                                              decoration: InputDecoration(
                                                  hintText: 'quantite'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            int qte = int.parse(
                                                _quantite.text.trim());

                                            final art = FirebaseFirestore
                                                .instance
                                                .collection('articles')
                                                .doc(datauser.docs[index].id);
                                            art.update({
                                              'quantite': qte,
                                            });
                                            //updateArticle(int.parse(_quantite.text.trim()));

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
                            child: Text("modifie quantite et image du produit"))
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
