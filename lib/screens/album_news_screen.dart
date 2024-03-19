import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Models/album.dart';
import '../provider/provider.dart';

// -- les derniers albums (news)
class AlbumNewsScreen extends StatefulWidget {
  const AlbumNewsScreen({super.key});
  @override
  State<AlbumNewsScreen> createState() => _AlbumNewsScreenDetail();
}

class _AlbumNewsScreenDetail extends State<AlbumNewsScreen> {

  late Provider _provider;
  late List<Album> _album;
  //late Album _album;

  @override
  void initState() {
    super.initState();
    _provider = Provider();
    _get();
  }

  void _get() async {
    var result = await _provider.fetchAlbums();
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
    appBar: AppBar(title: const Text('Album News Screen')),
    body: Center(
      child: ListView.builder(
        itemCount: _album.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {  },
            child: Text(_album[index].toString()),
          );
        },
      ),
    ),
  );
}

}