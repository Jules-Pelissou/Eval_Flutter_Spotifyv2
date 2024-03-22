import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/Models/artiste.dart';
import 'package:just_audio/just_audio.dart';

import '../Models/album.dart';
import '../provider/provider.dart';

/// The details screen
class AlbumDetailScreen extends StatefulWidget {
  final String id;

  const AlbumDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

// final duration = await player.setUrl(           // Load a URL
//     'https://foo.com/bar.mp3');                 // Schemes: (https: | file: | asset: )
// player.play();                                  // Play without waiting for completion
// await player.play();                            // Play while waiting for completion
// await player.pause();                           // Pause but remain ready to play
// await player.seek(Duration(second: 10));        // Jump to the 10 second position
// await player.setSpeed(2.0);                     // Twice as fast
// await player.setVolume(0.5);                    // Half as loud
// await player.stop();                            // Stop and free resources

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final player = AudioPlayer();
  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );
  late Provider _provider;
  late Album _album;
  late Artist _artist;
  List _tracks = [];
  var playing = false;
  var pause = false;

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
      }
    });
  }

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
                    title: Text("$titre - $artist $explicit"),
                    subtitle: Text("$dureeemms minutes"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            var audioUrl = track.getAudioUrl();
                            if (audioUrl != null) {
                              var source = AudioSource.uri(Uri.parse(audioUrl));
                              await player.setAudioSource(source);
                              playing = true;
                              print("PLAYING THE PLAYTAPUS : $playing");
                              await player.play();
                              print("Écoute terminée");
                            } else {
                              print("Il n'y a pas de lien");
                            }
                          },
                          child: Text("Écouter"),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            var audioUrl = track.getAudioUrl();
                            if (audioUrl != null) {
                              playlist
                                  .add(AudioSource.uri(Uri.parse(audioUrl)));
                              print("Musique ajoutée à la playlist");
                              print(
                                  "Longueur de la playlist : ${playlist.length}");
                            } else {
                              print("Aucun lien");
                            }
                          },
                          child: Text("Ajouter à la playlist"),
                        ),
                        SizedBox(width: 8),
                        if (playing == true)
                          IconButton(
                            icon: const Icon(Icons.pause),
                            iconSize: 25,
                            onPressed: player.pause,
                          ),
                        if (pause == true)
                          ElevatedButton(
                            onPressed: () {
                              pause = false;
                              playing = true;
                              //player.resume();
                            },
                            child: Text("Reprendre"),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => context.go('/a'),
              child: const Text('Go back'),
            ),
            ElevatedButton(
              onPressed: () =>
                  context.go('/a/artistedetails/${_album.getArtistid()}'),
              child: const Text('Go Artiste Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
