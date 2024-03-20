import 'dart:js_interop';
import 'dart:convert';

import '../provider/provider.dart';

class Album {
  String _titre = "";
  String _image = "";
  String _id = "";
  String _artistname = "";
  List _tracks = [];
  Album({String titre = "", String image = "", String id="", String artistname ="", List tracks = const []}) {
    _titre = titre;
    _image = image;
    _id = id;
    _artistname = artistname;
    _tracks = tracks;
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

  getTracks(){
    return _tracks;
  }

  factory Album.fromJson(Map<String, dynamic> data) {
    return Album(
        titre: data['name'].toString() ?? "",
        image: data['images'][0]?['url'].toString() ?? "",
        id : data['id'].toString() ?? "",
        artistname : data['artists'][0]?['name'].toString() ?? "",
        //tracks : data['tracks'] ?? "",
        )
        ;
  }

  @override
  String toString() {
    return '$_titre';
    //$_artistname 
  }
}