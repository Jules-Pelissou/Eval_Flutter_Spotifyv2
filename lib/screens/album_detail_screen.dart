import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/Models/artiste.dart';

import '../Models/album.dart';
import '../provider/provider.dart';

/// The details screen
class AlbumDetailScreen extends StatefulWidget {
  final String id;

  const AlbumDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late Provider _provider;
  late Album _album;
  late Artist _artist;
  List _tracks = [];

  @override
  void initState() {
    super.initState();
    _provider = Provider();
    _get();
  }

  void _get() async {
    var result = await _provider.fetchAlbum(id: widget.id);
    var tracklist = await _provider.fetchTracks(id: widget.id);
    print(result);
    setState(() {
      if (result != null) {
        _album = result;
        _tracks = tracklist;
        //_artist = artiste!;
      }
    });
  }

// -- detail d'un album
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details Screen')),
      body: Center(
          child: Column(
        children: [
          Image.network(
            _album.getImage(),
            width: 250,
            height: 250,
          ),
          Text(_album.getTitre()),
          Text(_album.getArtistname()),
          Expanded(
            child: ListView.builder(
              itemCount: _tracks.length,
              itemBuilder: (BuildContext context, int index) {
                var track = _tracks[index];

                String titre = track.getTitre();

                // Calcul de la durée


                double dureeemms = track.getDuree();
                dureeemms = (dureeemms / 1000) as double;
                dureeemms = dureeemms / 60;
                String formattedDureeemms = dureeemms.toStringAsFixed(2);
                dureeemms = double.parse(formattedDureeemms);

                String explicit = "";
                if (track.getExplicit() == false) {
                  explicit = "";
                } else {
                  explicit = "(Explicit)";
                }
                String artist = track.getArtistname();

                return ListTile(
                  leading: Image.network(
                  _album.getImage(),
                  width: 100,
                  height: 100,
                ),
                  title: Text("${_tracks[index].toString()} - $artist $explicit"),
                  subtitle: Text("$dureeemms minutes"),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => context.go('/a'),
            child: const Text('Go back'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/a/artistedetails/${_album.getArtistid ()}'),
            child: const Text('Go Artiste Detail'),
          ),
        ],
      )),
    );
  }
}
