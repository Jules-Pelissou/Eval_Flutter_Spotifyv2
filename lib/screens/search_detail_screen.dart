import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:projet_spotify_gorouter/Models/album.dart';
import 'package:projet_spotify_gorouter/Models/artiste.dart';
import 'package:projet_spotify_gorouter/Models/tracks.dart';
import 'package:projet_spotify_gorouter/provider/provider.dart';

/// The details screen
///
class SearchDetailsScreen extends StatefulWidget {
  final String recherche;
  final String type;
  const SearchDetailsScreen(
      {super.key, required this.recherche, required this.type});
  @override
  State<SearchDetailsScreen> createState() => _SearchScreenDetailState();
}

class _SearchScreenDetailState extends State<SearchDetailsScreen> {
  late List<Album> _album;
  late List<Artist> _artist;
  late List<Tracks> _tracks;
  late Provider _provider;
  final player = AudioPlayer();
  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );
  final rechercheController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = Provider();
    _get();
  }

  void _get() async {
    switch (widget.type) {
      case "Albums":
        var result = await _provider.fetchAlbumsBySearch(
            type: widget.type, recherche: widget.recherche);
        setState(() {
          if (result != null) {
            _album = result;
            print("Résultat de l'album : $_album");
          }
        });
        break;
      case "Artistes":
        print("Cas des artistes");
        var result = await _provider.fetchArtistsBySearch(
            type: widget.type, recherche: widget.recherche);
        setState(() {
          if (result != null) {
            _artist = result;
            print("Résultat de l'album : $_artist");
          }
        });
        break;
      case "Chansons":
        var result = await _provider.fetchTracksBySearch(
            type: widget.type, recherche: widget.recherche);
        setState(() {
          if (result != null) {
            _tracks = result;
            print("Résultat de l'album : $_tracks");
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Details Screen')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/b'),
            child: const Text('Go back to the Search screen'),
          ),
          if (widget.type == "Albums")
            Expanded(
              child: ListView.builder(
                itemCount: _album.length,
                itemBuilder: (context, index) {
                  final album = _album[index];
                  return Column(
                    children: [
                      Image.network(
                        album.getImage(),
                        width: 100,
                        height: 100,
                      ),
                      Text(album.getArtistname()),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .go('/a/albumdetails/${_album[index].getId()}');
                        },
                        child: Text(album.toString()),
                      ),
                    ],
                  );
                },
              ),
            ),
          if (widget.type == "Artistes")
            Expanded(
              child: ListView.builder(
                itemCount: _artist.length,
                itemBuilder: (context, index) {
                  final artist = _artist[index];
                  return Column(
                    children: [
                      Image.network(
                        artist.getImage(),
                        width: 100,
                        height: 100,
                      ),
                      Text(artist.getName()),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/a/artistedetails/${artist.getId()}');
                        },
                        child: Text(artist.getName()),
                      ),
                    ],
                  );
                },
              ),
            ),
          if (widget.type == "Chansons")
            Expanded(
              child: ListView.builder(
                itemCount: _tracks.length,
                itemBuilder: (BuildContext context, int index) {
                  var track = _tracks[index];

                  // Utilisation des propriétés du modèle Tracks
                  String titre = track.getTitre();
                  double dureeemms = track.getDuree() /
                      1000 /
                      60; // Conversion de la durée en minutes
                  String formattedDureeemms = dureeemms.toStringAsFixed(2);
                  String explicit = track.getExplicit() ? "(Explicit)" : "";
                  String artist = track.getArtistname();
                  String audioUrl = track.getAudioUrl();

                  return ListTile(
                    title: Text("$titre - $artist $explicit"),
                    subtitle: Text("$formattedDureeemms minutes"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (audioUrl != null && audioUrl.isNotEmpty) {
                              var source = AudioSource.uri(Uri.parse(audioUrl));
                              await player.setAudioSource(source);
                              await player.play();
                              print("Écoute terminée");
                            } else {
                              print("Il n'y a pas de lien audio");
                            }
                          },
                          child: Text("Écouter"),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (audioUrl != null && audioUrl.isNotEmpty) {
                              playlist
                                  .add(AudioSource.uri(Uri.parse(audioUrl)));
                              print("Musique ajoutée à la playlist");
                              print(
                                  "Longueur de la playlist : ${playlist.length}");
                            } else {
                              print("Aucun lien audio");
                            }
                          },
                          child: Text("Ajouter à la playlist"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
