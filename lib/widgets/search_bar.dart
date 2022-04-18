import 'package:flutter/material.dart';

class MySearchBar extends SearchDelegate {
  final data;
  String coinName = "";
  String coinId = "";

  MySearchBar({required this.data});
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = "";
            }
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<dynamic> suggestions = [];
          for (var item in snapshot.data) {
            // log(item['name']);
            suggestions.add(item['name']);
          }

          suggestions = suggestions
              .where((element) =>
                  element.toString().toLowerCase().startsWith(query))
              .toList();
          if (suggestions.isEmpty) {
            return const Center(
              child: Text("No matching coin name found 🙂"),
            );
          } else {
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                //
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    query = suggestion as String;
                    List<dynamic> temp = snapshot.data;
                    var selectedCoin = temp.firstWhere(
                        (element) => element['name'].toString() == query);

                    coinName = selectedCoin['name'] as String;
                    coinId = selectedCoin['id'] as String;
                    close(context, coinId + " " + coinName);
                  },
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Got some error try again later 😥"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<dynamic> suggestions = [];
          for (var item in snapshot.data) {
            // log(item['name']);
            suggestions.add(item['name']);
          }

          suggestions = suggestions
              .where((element) =>
                  element.toString().toLowerCase().startsWith(query))
              .toList();
          if (suggestions.isEmpty) {
            return const Center(
              child: Text("No matching coin name found 🙂"),
            );
          } else {
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                //
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    query = suggestion as String;
                    List<dynamic> temp = snapshot.data;
                    var selectedCoin = temp.firstWhere(
                        (element) => element['name'].toString() == query);

                    coinName = selectedCoin['name'] as String;
                    coinId = selectedCoin['id'] as String;
                    close(context, coinId + " " + coinName);
                  },
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Got some error try again later 😥"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
