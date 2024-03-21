import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/Models/album.dart';
import 'package:projet_spotify_gorouter/provider/provider.dart';

/// The details screen
/// 
class SearchDetailsScreen extends StatefulWidget {
  final String recherche;
  final String type;
  const SearchDetailsScreen({super.key, required this.recherche, required this.type});
  @override
  State<SearchDetailsScreen> createState() => _SearchScreenDetailState();
}

class _SearchScreenDetailState extends State<SearchDetailsScreen> {
  
  
  late List<Album> _album;
  late Provider _provider;
  final rechercheController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = Provider();
    _get();
  }

  void _get() async {
    var result = await _provider.fetchAlbumsBySearch(type : widget.type,  recherche: widget.recherche);
    print(result);
    setState(() {
      if (result != null) {
        _album = result;
        print("Résultat de l'album : $_album");
      }
    });
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
                        context.go('/a/albumdetails/${_album[index].getId()}');
                      },
                      child: Text(album.toString()),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
      ),
    );
  }
}



// var result = await _provider.fetchAlbumsBySearch(recherche: );
//     print(result);
//     setState(() {
//       if (result != null) {
//         _album = result;
//         print("Résultat de l'album : $_album");
//       }
//     });