import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movup/Screens/cliennt_screen.dart';
import 'package:movup/Screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movup/Screens/vendeur_screen.dart';
import 'package:movup/User_class.dart';

class HomeScreen extends StatefulWidget {
 // const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> users =
            FirebaseFirestore.instance.collection('Users').where("userid" ,isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString()).snapshots();



  @override
  Widget build(BuildContext context) {

    return
      StreamBuilder<QuerySnapshot>(stream: users,builder:(BuildContext context,  AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  return Text("something wrong");
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text("Loading wait few instance");

                }
                final datauser=snapshot.requireData;
                if(datauser.docs[0]["role"]=='vendeur')
                  {
                    return vendeur_screen();
                  }else if(datauser.docs[0]["role"]=='client'){
                 return client_screen();
                }else
                  return client_screen();
                /*return ListView.builder(
                  itemCount: datauser.size,
                  itemBuilder: (context, index){
                    return Text('user name ${datauser.docs[index]['username']} and his role is ${datauser.docs[index]['role']} ');
                  },
                );*/
              },
              );

  }
}