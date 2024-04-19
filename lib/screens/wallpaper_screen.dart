import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/screens/full_screen.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  List photos = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  // fetch api data
  void fetchApi() async {
    String auth = dotenv.env['API_KEY']!;

    var url = "https://api.pexels.com/v1/curated";
    await http.get(Uri.parse("$url?per_page=80"), headers: {
      "Authorization": auth,
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        photos.addAll(result['photos']);
      });
      // print(photos[0]);
    });
  }

  // Load More Images
  void loadMore() async {
    String auth = dotenv.env['API_KEY']!;
    setState(() {
      page = page + 1;
    });
    String url = 'https://api.pexels.com/v1/curated?per_page=80&page=$page';
    await http
        .get(Uri.parse(url), headers: {'Authorization': auth}).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        photos.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallpaper App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                  itemCount: photos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreen(
                                image: photos[index]['src']['original'],
                                id: photos[index]['id'].toString(),
                              ),
                            ));
                      },
                      child: Hero(
                        tag: photos[index]['id'].toString(),
                        child: Container(
                          color: Colors.grey,
                          child: Image.network(
                            photos[index]['src']['tiny'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          InkWell(
            onTap: () {
              loadMore();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.blue,
              child: const Center(child: Text("Load More")),
            ),
          ),
        ],
      ),
    );
  }
}
