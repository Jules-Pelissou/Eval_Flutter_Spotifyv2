import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/Models/album.dart';
import 'package:projet_spotify_gorouter/provider/provider.dart';
import 'package:projet_spotify_gorouter/screens/search_detail_screen.dart';

class BoutonSelection extends StatefulWidget {
  const BoutonSelection({Key? key, required this.onValueChanged}) : super(key: key);

  final void Function(String) onValueChanged;

  @override
  State<BoutonSelection> createState() => _BoutonSelectionState();
}

class _BoutonSelectionState extends State<BoutonSelection> {
  static const List<String> list = <String>['Albums', 'Artistes', 'Chansons'];
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          widget.onValueChanged(dropdownValue); // Appel du callback avec la valeur sélectionnée
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenDetail();
}

class _SearchScreenDetail extends State<SearchScreen> {
  late List<Album> _album;
  late Provider _provider;
  final rechercheController = TextEditingController();
  String selectedValue = 'Albums'; // Initial value

  @override
  void initState() {
    super.initState();
    _provider = Provider();
    _get();
  }

  void _get() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Screen')),
      body: Column(
        children: [
          TextField(
            controller: rechercheController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Rechercher un album",
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  context.go("/b/searchdetails/$selectedValue/${rechercheController.text}");
                  //SearchDetailsScreen(recherche: rechercheController.text, type : selectedValue);
                },
              ),
            ),
          ),
          BoutonSelection(
            onValueChanged: (value) {
              setState(() {
                selectedValue = value; 
              });
            },
          ),
          ElevatedButton(
            onPressed: () => context.go('/b/searchdetails'),
            child: const Text('Go to the search Details screen'),
          ),
        ],
      ),
    );
  }
}
