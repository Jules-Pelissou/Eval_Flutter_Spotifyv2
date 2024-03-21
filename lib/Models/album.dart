import 'dart:js_interop';
import 'dart:convert';

class Album {
  String _titre = "";
  String _image = "";
  String _id = "";
  String _artistname = "";
  String _artistid = "";
  
  Album({String titre = "", String image = "", String id="", String artistname ="", String artistid=""}) {
    _titre = titre;
    _image = image;
    _id = id;
    _artistname = artistname;
    _artistid = artistid;
  }

  getTitre() {
    return _titre;
  }

  getImage() {
    return _image;
  }

  getId(){
    return _id;
  }

  getArtistname(){
    return _artistname;
  }

  getArtistid(){
    return _artistid;
  }



  factory Album.fromJson(Map<String, dynamic> data) {
    return Album(
        titre: data['name'].toString() ?? "",
        image: data['images'][0]?['url'].toString() ?? "",
        id : data['id'].toString() ?? "",
        artistname : data['artists'][0]?['name'].toString() ?? "",
        artistid : data['artists'][0]?['id'].toString() ?? "",
        )
        ;
  }

  @override
  String toString() {
    return '$_titre';
  }
}