import 'dart:js_interop';
import 'dart:convert';

import '../provider/provider.dart';

class Album {
  String _titre = "";
  String _image = "";
  Album(
      {
      String titre = "",
      String image = ""
      }) 
  {
    _titre = titre;
    _image = image;
  }

  getTitre(){
    return _titre;
  }

  getImage(){
    return _image;
  }
  
  factory Album.fromJson(Map<String, dynamic> data) {
    return Album(
        titre: data['name'].toString() ?? "",
        image: data['image']?['url'].toString() ?? "");
  }

  @override
  String toString() {
    return (_titre);
    //return ("Bonjour");
  }

  
}

// Future<Album?> fetchAlbum({String name = ""}) async {
 
//   var url = Uri.https(urlApiAlbumDomain, '$urlApiAlbum/$name');
//   var response = await http.get(url);
//   Map<String, dynamic> data = jsonDecode(response.body);
//     Album poke = Album.fromJson(data);
//     return poke;
  
// }

// Future<List<Album>> fetchAlbums({int page = 0}) async {
//   List<Album> list = [];
//   var offset = 20 * (page - 1);
//   var url = Uri.https(
//       urlApiAlbumDomain, urlApiAlbum, {"offset": offset.toString()});
//   var response = await http.get(url);
//   var data = jsonDecode(response.body);
//   data['results'].forEach((Album) => list.add(Album.fromJson(Album)));
//   return (list);
// }