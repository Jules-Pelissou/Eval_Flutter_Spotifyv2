import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';


import '../Models/album.dart';
import '../provider/provider.dart';
import '../Models/artiste.dart';

// -- detail d'un artiste
class ArtisteDetailScreen extends StatefulWidget {
  final String id;
  const ArtisteDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ArtisteDetailScreen> createState() => _ArtisteDetailScreenState();
}

class _ArtisteDetailScreenState extends State<ArtisteDetailScreen> {
  final player = AudioPlayer();
  final playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );
  late Provider _provider;
  late Artist _artist;
  List _tracks = [];

  @override
  void initState() {
    super.initState();
    _provider = Provider();
    _get();
  }

 

  void _get() async {
    var result = await _provider.fetchArtistFonctAlbum(id: widget.id);
    var tracklist = await _provider.fetchTracksFromArtist(id: widget.id);
    print("Salut c'est ninho : $result");
    print("Salut c'est JOHNY HALLYDAY $tracklist");
    setState(() {
      if (result != null) {
        _artist = result;
        _tracks = tracklist;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artist Screen')),
      body: Center(
        child: Column(
          children: [
            Image.network(
              _artist.getImage(),
              width: 250,
              height: 250,
            ),
            Text(_artist.getName()),
            Text('Followers : ${_artist.getFollowers()}'),
            Text(
                'Popularité : ${_artist.getPopularity()}'),
            Expanded(
              child: ListView.builder(
                itemCount: _artist.getGenre().length,
                itemBuilder: (context, index) {
                  return Text(_artist.getGenre()[index]);
                },
              ),
            ),

            // Faire afficher les tracklist mais fait rien afficher + fait bugger la page d'accueil

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
                              playlist.add(AudioSource.uri(Uri.parse(audioUrl)));
                              print("Musique ajoutée à la playlist");
                              print("Longueur de la playlist : ${playlist.length}");
                              //print("La playlist : ${playlist.toString()}");
                            } else {
                              print("Aucun lien");
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
            ElevatedButton(
              onPressed: () => context.go('/a'),
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
