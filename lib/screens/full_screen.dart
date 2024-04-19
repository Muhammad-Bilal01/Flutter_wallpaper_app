import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart";
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FullScreen extends StatefulWidget {
  const FullScreen({super.key, required this.image, required this.id});

  final String image, id;
  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  void setWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN; //can be Home/Lock Screen
    File file = await DefaultCacheManager().getSingleFile(widget.image);
    bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: widget.id,
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // setWallpaper();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.blue,
              child: const Center(child: Text("Set Homescreen")),
            ),
          ),
        ],
      ),
    );
  }
}
