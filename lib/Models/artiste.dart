import 'dart:js_interop';
import 'dart:convert';

class Artist {

  String _name = "";
  int _popularity = 0;
  String _id = "";
  String _image = "";
  List _genre = [];
  int _followers = 0;
  Artist({String titre = "", String image = "", String id="", int popularity =0, List genre = const [], int followers = 0}) {
    _name = titre;
    _image = image;
    _id = id;
    _popularity = popularity;
    _genre = genre;
    _followers = followers;
  }

  getName() {
    return _name;
  }

  getImage() {
    return _image;
  }

  getId(){
    return _id;
  }

  getPopularity(){
    return _popularity;
  }

  List<String> getGenre(){
  return List<String>.from(_genre);
}


  getFollowers(){
    return _followers;
  }

  factory Artist.fromJson(Map<String, dynamic> data) {
    return Artist(
        titre: data['name'].toString() ?? "",
        image: data['images'][0]?['url'].toString() ?? "",
        id : data['id'].toString() ?? "",
        popularity : data['popularity'] ?? "",
        genre : List<String>.from(data['genres'] ?? []),
        followers: data['followers']?['total'] ?? "");
  }

  @override
  String toString() {
    return '$_name $_popularity $_id $_followers $_genre';
  }

}

