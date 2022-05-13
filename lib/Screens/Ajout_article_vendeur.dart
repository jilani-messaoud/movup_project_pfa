import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movup/Screens/Vendeur_produit_screen.dart';
import 'package:movup/Screens/home_screen.dart';
import 'package:movup/Services/storage_services.dart';
import 'package:movup/Utils/color_utils.dart';
import 'package:movup/reusable_widgets/reusable_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ajout_article_vendeur extends StatefulWidget {
  const ajout_article_vendeur({Key? key}) : super(key: key);

  @override
  State<ajout_article_vendeur> createState() => _ajout_article_vendeurstate();
}

class _ajout_article_vendeurstate extends State<ajout_article_vendeur> {
  CollectionReference articles =
      FirebaseFirestore.instance.collection("articles");
  final Storage storage = Storage();
  TextEditingController _ref = TextEditingController();
  TextEditingController _qte = TextEditingController();
  TextEditingController _nom = TextEditingController();
  String? filename;
  String? image_url;
  final categories = [
    'informatique',
    'electromenage',
    'nourriture',
    'decoration'
  ];
  String? categories_val;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                reusableTextField(
                    "reference", Icons.format_color_text, false, _ref),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("nom", Icons.format_color_text, false, _nom),
                const SizedBox(
                  height: 20,
                ),
                /*TextField(
                  controller: _qte,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.confirmation_number,
                      color: Colors.white70,
                    ),
                    labelText: "qauntite",
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                  ),
                  keyboardType: TextInputType.number,
                ),*/

                reusableTextField(
                    "quantite", Icons.format_color_text, false, _qte),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg'],
                    );
                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("aucune fichier selectionnee"),
                        ),
                      );
                      return null;
                    }
                    final path = result.files.single.path!;
                    filename = result.files.single.name;
                    image_url = await storage.downloadURL(filename!).toString();
                    storage.uploadFile(path, filename!).then((value) =>
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("done"))));
                    //ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(result.files.single.name.toString())));

                    print(filename);
                    print(path);
                  },
                  child: Text('Upload File'),
                ),
                DropdownButton<String>(
                  hint: Text("selectionner categorie"),
                  value: categories_val,
                  isExpanded: true,
                  items: categories.map(buildmenucategories).toList(),
                  onChanged: (categories_val) =>
                      setState(() => this.categories_val = categories_val),
                ),
                ElevatedButton(
                    onPressed: () {
                      articles
                          .add({
                            "Vendeur_id": FirebaseAuth.instance.currentUser!.uid
                                .toString()
                                .trim(),
                            "Reference": _ref.text.trim(),
                            "Nom": _nom.text.trim(),
                            "quantite": int.parse(_qte.text.trim()),
                            "categorie": categories_val,
                            "image": filename,
                          })
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      vendeur_screen_produit())))
                          .onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                    },
                    child: Text("ajouter l'article")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildmenucategories(String categories) =>
      DropdownMenuItem(
        value: categories,
        child: Text(
          categories,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      );
}
