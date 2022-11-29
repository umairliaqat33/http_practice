import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_practice/model/album.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: FutureBuilder<List<Album>>(
          future: fetchAlbum(http.Client()),
          builder: (context,snapshot) {
            final album = snapshot.data;
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.data == null) {
              return const Text("No albums to show");
            }

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemCount: album!.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    title: Text(album[index].title),
                    leading: Text(album[index].id.toString()),
                    trailing: Text(album[index].userId.toString()),
                  );
                },),
            );
          },
        ),
      ),
    );
  }
  List<Album> parseAlbum(String responseBody){
    final response=jsonDecode(responseBody).cast<Map<String,dynamic>>();
    return response.map<Album>((json)=>Album.fromJson(json)).toList();
  }

  Future<List<Album>> fetchAlbum(http.Client client) async {
    final list=await client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));
    return parseAlbum(list.body);
  }
}
