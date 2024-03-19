import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/album.dart';

const urlApiAlbumDomain = 'api.spotify.com';
const urlApiAlbum = '/api/v1';
const token = 'BQC5JEXf6Wg1whtwSHtqxCCMabHj4369bHepVOY9hJIXappafe6wXdY7jK369LfZYaYWg8u2RBZ1Vdk-qU_YCzV3VrAMmt7jhabZE8STgy7I5EVWi2c';

//  const headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $token',
//   };

class Provider{

Future<Album?> fetchAlbum() async {
 
  var url = Uri.https(urlApiAlbumDomain, '$urlApiAlbum/browse/new-releases');
  //urlApiAlbumDomain, '$urlApiAlbum/browse/new-releases'
  print(url);
  var response = await http.get(
    url,
    headers : {'Authorization' : 'Bearer $token'}
    );
  Map<String, dynamic> data = jsonDecode(response.body);
    final Album album = Album.fromJson(data);
    print(data);
    return album;
}

Future<List<Album>> fetchAlbums() async {

  List<Album> list = [];
  //var offset = 20 * (page - 1);

  var url = Uri.https(
      urlApiAlbumDomain, '/$urlApiAlbum/browse/new-releases'
      //'api.spotify.com', 'v1/browse/new-releases'
      //urlApiAlbumDomain, '$urlApiAlbum/browse/new-releases'
      );
  var response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );
  var data = jsonDecode(response.body);
  //print('La liste qui est $data');
  data['albums']['items']?.forEach((album) => list.add(Album.fromJson(album)));
  //list.add(Album.fromJson(album)));
  return (list);
}

}