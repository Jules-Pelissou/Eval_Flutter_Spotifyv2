import 'dart:js_interop';

import 'package:http/http.dart' as http;
import 'package:projet_spotify_gorouter/Models/artiste.dart';
import 'dart:convert';
import '../Models/album.dart';
import '../Models/tracks.dart';
import '../Models/artiste.dart';

const urlApiAlbumDomain = 'api.spotify.com';

const urlApiAlbum = '/api/v1';

const urlApiAlbumSpe = '/v1/albums';

const urlApiArtistSpe = '/v1/artists';

const token = 'BQCD9dNcjPGhgtbPFUGd1SJ6i-FhkHikA8xMiRcn4y7zkFyT7Gd2U2H8fBYPhRCDbmr3LshA2oyZ77Ra_H6ZI9QJ2KmeIZMzHwDc56-uirfdSKdN8MA';

class Provider{

// Provider pour un Album spécifique

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

// Provider pour toutes les tracks d'un album spécifique

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

// Provider de tous les albums (dernières sorties)

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

// Provider d'un artiste spécifique

Future<Artist?> fetchArtistFonctAlbum({required String id}) async {
 
  var url = Uri.https(urlApiAlbumDomain, '$urlApiArtistSpe/$id');
  var response = await http.get(
    url,
    headers : {'Authorization' : 'Bearer $token'}
    );
  Map<String, dynamic> data = jsonDecode(response.body);
    final Artist artist = Artist.fromJson(data);
    return artist;
}

Future<List<Tracks>> fetchTracksFromArtist({required String id}) async{

  List<Tracks> tracklist = [];

  var url = Uri.https(urlApiAlbumDomain, '/artists/$id/top-tracks/');
  var response = await http.get(
    url,
    headers : {'Authorization' : 'Bearer $token'}
    );
  Map<String, dynamic> data = jsonDecode(response.body);
    data['tracks']?.forEach((track) => tracklist.add(Tracks.fromJson(track)));
    print(data);
    return tracklist;
}


}