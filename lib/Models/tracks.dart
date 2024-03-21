import 'dart:js_interop';
import 'dart:convert';

class Tracks {
  String _titre = "";
  bool _explicit = false;
  String _id = "";
  String _artistname = "";
  int _duree = 0;
  String _urlaudio ="";
  Tracks({String titre = "", bool explicit = false, String id="", String artistname ="", int duree = 0, String urlaudio = ""}) {
    _titre = titre;
    _explicit = explicit;
    _id = id;
    _artistname = artistname;
    _duree = duree;
    _urlaudio = urlaudio;
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

  getAudioUrl(){
    return _urlaudio;
  }

  factory Tracks.fromJson(Map<String, dynamic> data) {
    return Tracks(
        titre: data['name'].toString() ?? "",
        explicit: data['explicit'] ?? false,
        id : data['id'].toString() ?? "",
        artistname : data['artists'][0]?['name'].toString() ?? "",
        duree : data['duration_ms'] ?? 0,
        urlaudio: data["preview_url"].toString() ?? "",
        );
  }

  @override
  String toString() {
    return '$_titre';
  }
}