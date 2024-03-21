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

const token =
    'BQAdKbe4gMdHJxhvvbL5bGW3oVcYy-q94mjbMCzpceMdPAsMhGG8B_7SYeZvmJ_ol-Qt6uAPhUV4JNVN3Io3Qj-5i56Z3ccaUcFI3HGoeHZYzRMSJds';

class Provider {
// Provider pour un Album spécifique

  Future<Album?> fetchAlbum({required String id}) async {
    var url = Uri.https(urlApiAlbumDomain, '$urlApiAlbumSpe/$id');
    //urlApiAlbumDomain, '$urlApiAlbum/browse/new-releases'
    print(url);
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    Map<String, dynamic> data = jsonDecode(response.body);
    final Album album = Album.fromJson(data);
    print(data);
    return album;
  }

// Provider pour toutes les tracks d'un album spécifique

  Future<List<Tracks>> fetchTracks({required String id}) async {
    List<Tracks> tracklist = [];

    var url = Uri.https(urlApiAlbumDomain, '$urlApiAlbumSpe/$id');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    Map<String, dynamic> data = jsonDecode(response.body);
    data['tracks']['items']
        ?.forEach((track) => tracklist.add(Tracks.fromJson(track)));
    print(data);
    return tracklist;
  }

// Provider de tous les albums (dernières sorties)

  Future<List<Album>> fetchAlbums() async {
    List<Album> list = [];
    //var offset = 20 * (page - 1);

    var url = Uri.https(urlApiAlbumDomain, '/$urlApiAlbum/browse/new-releases'
        //'api.spotify.com', 'v1/browse/new-releases'
        //urlApiAlbumDomain, '$urlApiAlbum/browse/new-releases'
        );
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    var data = jsonDecode(response.body);
    //print('La liste qui est $data');
    data['albums']['items']
        ?.forEach((album) => list.add(Album.fromJson(album)));
    //list.add(Album.fromJson(album)));
    return (list);
  }

// Provider d'un artiste spécifique

  Future<Artist?> fetchArtistFonctAlbum({required String id}) async {
    var url = Uri.https(urlApiAlbumDomain, '$urlApiArtistSpe/$id');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    Map<String, dynamic> data = jsonDecode(response.body);
    final Artist artist = Artist.fromJson(data);
    return artist;
  }

  Future<List<Tracks>> fetchTracksFromArtist({required String id}) async {
    List<Tracks> tracklist = [];

    var url = Uri.https(urlApiAlbumDomain, '/v1/artists/$id/top-tracks');
    print(url);
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    Map<String, dynamic> data = jsonDecode(response.body);
    data['tracks']?.forEach((track) => tracklist.add(Tracks.fromJson(track)));
    print(data);
    return tracklist;
  }

  Future<List<Album>> fetchAlbumsBySearch(
      {required String recherche, required String type}) async {
    List<Album> resultats = [];
    print("Dans la recherche");
    var url = Uri.parse(
        'https://$urlApiAlbumDomain/v1/search?type=album&market=FR&q=$recherche');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body);
    print('La liste qui est $data');
    data['albums']['items']?.forEach(
        (searchedAlbum) => resultats.add(Album.fromJson(searchedAlbum)));
    //list.add(Album.fromJson(album)));
    return (resultats);
  }

  Future<List<Artist>> fetchArtistsBySearch(
      {required String recherche, required String type}) async {
    List<Artist> resultats = [];
    
    var encodedRecherche = Uri.encodeComponent(recherche);

    var url = Uri.parse(
    'https://$urlApiAlbumDomain/v1/search?type=artist&market=FR&q=$encodedRecherche');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body);
    print('La liste qui est $data');
    data['artists']['items']?.forEach(
        (searchedAlbum) => resultats.add(Artist.fromJson(searchedAlbum)));
    //list.add(Album.fromJson(album)));
    return (resultats);
  }

Future<List<Tracks>> fetchTracksBySearch(
    {required String recherche, required String type}) async {
  List<Tracks> resultats = [];
  var url = Uri.parse(
    'https://$urlApiAlbumDomain/v1/search?q=$recherche&type=track&market=FR');
  var response =
      await http.get(url, headers: {'Authorization': 'Bearer $token'});
  var data = jsonDecode(response.body);
  print('La liste qui est $data');
  // Vérifier si "tracks" existe dans la réponse
    data['tracks']?.forEach(
        (searchedTrack) => resultats.add(Tracks.fromJson(searchedTrack)));


  return resultats;
}


}


// case "Albums":
//         var url = Uri.parse(
//             'https://$urlApiAlbumDomain/v1/search?type=album&market=FR&q=$recherche');
//         var response =
//             await http.get(url, headers: {'Authorization': 'Bearer $token'});
//         var data = jsonDecode(response.body);
//         print('La liste qui est $data');
//         data['albums']['items']?.forEach(
//             (searchedAlbum) => resultats.add(Album.fromJson(searchedAlbum)));
//         //list.add(Album.fromJson(album)));
//         return (resultats);

//       case "Chansons":
//         var url = Uri.parse(
//             'https://$urlApiAlbumDomain/v1/search?type=track&market=FR&q=$recherche');
//         var response =
//             await http.get(url, headers: {'Authorization': 'Bearer $token'});
//         var data = jsonDecode(response.body);
//         print('La liste qui est $data');
//         data['albums']['items']?.forEach(
//             (searchedAlbum) => resultats.add(Album.fromJson(searchedAlbum)));
//         //list.add(Album.fromJson(album)));
//         return (resultats);
