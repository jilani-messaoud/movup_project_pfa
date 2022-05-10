// ignore_for_file: deprecated_member_use



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movup/Services/storage_services.dart';
import 'package:movup/Utils/color_utils.dart';
import 'package:movup/article_data.dart';
class client_screen extends StatelessWidget {
  final Stream<QuerySnapshot> articles =
  FirebaseFirestore.instance.collection('articles').snapshots();
  final Storage storage = Storage();




 /*
 article a = new article("Nom", "Reference", "Vendeur_id","categorie", "image", "quantite");
 Future<void> getData() async {
   // Get docs from collection reference
    QuerySnapshot querySnapshot = await articles.get();

   // Get data from docs and convert map to List
      List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();


   for (var element in allData) {
    print(element.toString());
     a= element as article;
     art.add(a);
   }


 }*/

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
          child: StreamBuilder<QuerySnapshot>(stream: articles,builder:(BuildContext context,  AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Text("something wrong");
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Text("Loading wait few instance");

            }
            final datauser=snapshot.requireData;
             return
             ListView.builder(
                itemCount: snapshot.requireData.size,
                 itemBuilder: (BuildContext context, int index)
            {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery
                    .of(context)
                    .size
                    .height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[

                    Text(datauser.docs[index]["Nom"].toString()),
                    Text(datauser.docs[index]["Reference"].toString()),
                    Text(datauser.docs[index]["Vendeur_id"].toString()),
                    Text(datauser.docs[index]["categorie"].toString()),
                    Text(datauser.docs[index]["quantite"].toString()),

                    FutureBuilder(
                        future: storage.downloadURL(datauser.docs[index]["image"]),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot){

                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData){
                            return Container(
                                width: 300,
                                height: 250,
                                child: Image.network(snapshot.data!, fit: BoxFit.cover)
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.waiting ||
                              !snapshot.hasData){
                            return CircularProgressIndicator();
                          }
                          return Container();
                        }
                    ),
                  ElevatedButton(onPressed:(){

                    

                  }, child: Text("acheter produit"))

                  ],
                ),
              );

            },

             );
            /*return ListView.builder(
                  itemCount: datauser.size,
                  itemBuilder: (context, index){
                    return Text('user name ${datauser.docs[index]['username']} and his role is ${datauser.docs[index]['role']} ');
                  },
                );*/
          },
          ),

      ),

    );

  }


}
