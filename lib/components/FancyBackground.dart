import 'dart:math';

import 'package:flutter/material.dart';

class FancyBackground extends StatefulWidget {
  @override
  _FancyBackgroundState createState() => _FancyBackgroundState();
}

class _FancyBackgroundState extends State<FancyBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(generateRandomBackground()),
        ),
      ),
    );
  }

  String generateRandomBackground() {
    var rng = new Random();
    var backgrounds = [
      "https://media.giphy.com/media/xUA7b6ss1J4EnvkLQY/source.gif",
      "https://media.giphy.com/media/l0Iy0nPSr5R2nkzO8/source.gif",
      "https://media.giphy.com/media/3oKIPEoTFhwXtkXyc8/source.gif",
      "https://media.giphy.com/media/l0K4aAjMMROnB6AOk/source.gif",
      "https://media.giphy.com/media/l378deJmgat6v6iyY/source.gif"
      "https://media.giphy.com/media/3ov9jNFwV8DIzOd7xe/source.gif"
    ];

    return backgrounds[rng.nextInt(backgrounds.length)];
  }
}
