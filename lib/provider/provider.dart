import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/album.dart';
import '../Models/tracks.dart';

const urlApiAlbumDomain = 'api.spotify.com';
const urlApiAlbum = '/api/v1';
const urlApiAlbumSpe = '/v1/albums';
const token = 'BQCOsrAPq6S_Unsh02lypWWyZs3ieLKh3UZjR6b-ctg_-WW-V8GkSLmCWvaREHuwwU0zs5YWDRujVxxt1cIDvW6WPclU5G30TZ3o5tm1PpYWRc5qkAE';

class Provider{

Future<Album?> fetchAlbum({required String id}) async {
 
  var url = Uri.https(urlApiAlbumDomain, '$urlApiAlbumSpe/$id');
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

Future<List<Tracks>> fetchTracks({required String id}) async{

  List<Tracks> tracklist = [];

  var url = Uri.https(urlApiAlbumDomain, '$urlApiAlbumSpe/$id');
  var response = await http.get(
    url,
    headers : {'Authorization' : 'Bearer $token'}
    );
  Map<String, dynamic> data = jsonDecode(response.body);
    data['tracks']['items']?.forEach((track) => tracklist.add(Tracks.fromJson(track)));
    print(data);
    return tracklist;
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