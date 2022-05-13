import 'dart:convert';

class article{
   String Nom;
  String Reference;
   String Vendeur_id;
  String categorie;
  String image;
   int quantite;

   article(
 this.Nom,
    this.Reference,
    this.Vendeur_id,
    this.categorie,
    this.image,
   this.quantite
 );

}
/*
factory article.formJson(Map<String , dynamic>json){
return article(
Nom : json['Nom'],
Reference : json['Reference'],
Vendeur_id : json['Vendeur_id'],
categorie : json['categorie'],
image : json['image'],
quantite: json['quantite'],
);
}

Future<article> updateArticle(int quantite) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'quantite': quantite,
    }),
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return article.formJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to update album.');
  }
} */
