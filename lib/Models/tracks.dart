import 'dart:js_interop';
import 'dart:convert';

import '../provider/provider.dart';

class Tracks {
  String _titre = "";
  bool _explicit = false;
  String _id = "";
  String _artistname = "";
  int _duree = 0;
  Tracks({String titre = "", bool explicit = false, String id="", String artistname ="", int duree = 0}) {
    _titre = titre;
    _explicit = explicit;
    _id = id;
    _artistname = artistname;
    _duree = duree;
  }

  getTitre() {
    return _titre;
  }

  getExplicit() {
    return _explicit;
  }

  getId(){
    return _id;
  }

  getArtistname(){
    return _artistname;
  }

  getDuree(){
    return _duree;
  }

  factory Tracks.fromJson(Map<String, dynamic> data) {
    return Tracks(
        titre: data['name'].toString() ?? "",
        explicit: data['explicit'] ?? false,
        id : data['id'].toString() ?? "",
        artistname : data['artists'][0]?['name'].toString() ?? "",
        duree : data['duration_ms'] ?? 0,
        );
  }

  @override
  String toString() {
    return '$_titre';
  }
}