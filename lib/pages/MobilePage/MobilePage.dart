import 'dart:html' as html;

import 'package:flutter/material.dart';

class MobilePage extends StatefulWidget {
  @override
  _MobilePageState createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.height * 0.30,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("https://avatars3.githubusercontent.com/u/44241397"),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Mobile Devices werden von Mobilita nicht unterstützt.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                "Genau für diesen Fall haben wir unsere Android App The Public Transport erschaffen.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Center(
              child: Text(
                "Es bietet sogar noch mehr Funktionen als Mobilita ;)",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  html.window.open("https://play.google.com/store/apps/details?id=de.pdesire.thepublictransportapp", "ThePublicTransport");
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage("https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
