import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mobilita/animations/ShowUp.dart';
import 'package:mobilita/components/AdvancedListTile.dart';
import 'package:mobilita/components/AdvancedSwitchListTile.dart';
import 'package:mobilita/components/FancyBackground.dart';
import 'package:mobilita/components/SearchBar.dart';
import 'package:mobilita/pages/ResultPage/ResultPageWide.dart';
import 'package:mobilita/pages/SearchInputPage/SearchInputPageWide.dart';
import 'package:mobility_framework/backend/models/main/SuggestedLocation.dart';
import 'package:user_agent/user_agent.dart';

class StartPageWide extends StatefulWidget {
  StartPageWide({Key key}) : super(key: key);

  @override
  _StartPageWideState createState() => _StartPageWideState();
}

class _StartPageWideState extends State<StartPageWide> {
  GlobalKey<AdvancedSwitchListTileState> fastestRouteSwitch = GlobalKey();
  bool _fastestRoute = true;

  GlobalKey<AdvancedSwitchListTileState> barrierSwitch = GlobalKey();
  bool _barrier = false;

  GlobalKey<AdvancedSwitchListTileState> slowSwitch = GlobalKey();
  bool _slow = false;

  TimeOfDay setup_time = new TimeOfDay.now();
  DateTime setup_date = new DateTime.now();

  SuggestedLocation from_search;
  SuggestedLocation to_search;

  GlobalKey<SearchbarState> fromSearchbar = GlobalKey();
  GlobalKey<SearchbarState> toSearchbar = GlobalKey();

  String dataMode = "DB";

  bool highspeed = true;
  bool regional = true;
  bool suburban = true;
  bool subway = true;
  bool tram = true;
  bool bus = true;
  bool ferry = true;
  bool ondemand = true;

  GlobalKey<AdvancedSwitchListTileState> highspeedSwitch = GlobalKey();
  GlobalKey<AdvancedSwitchListTileState> regionalSwitch = GlobalKey();
  GlobalKey<AdvancedSwitchListTileState> suburbanSwitch = GlobalKey();
  GlobalKey<AdvancedSwitchListTileState> subwaySwitch = GlobalKey();
  GlobalKey<AdvancedSwitchListTileState> tramSwitch = GlobalKey();
  GlobalKey<AdvancedSwitchListTileState> busSwitch = GlobalKey();
  GlobalKey<AdvancedSwitchListTileState> ferrySwitch = GlobalKey();
  GlobalKey<AdvancedSwitchListTileState> ondemandSwitch = GlobalKey();

  @override
  void initState() {
    var ua = new UserAgent(html.window.navigator.userAgent);
    if (ua.isAndroidPhone || ua.isWindowsPhone || ua.isBlackberryPhone) {
      Navigator.pushNamed(context, "/mobile");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            FancyBackground(),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width * 0.60,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.network("https://avatars2.githubusercontent.com/u/58031557")
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                "Mobilita (Alpha)",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Alata'
                                ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.29,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Searchbar(
                                  key: fromSearchbar,
                                  text: "Start",
                                  onTap: () async {
                                    SuggestedLocation location = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchInputPageWide(data: dataMode)));
                                    if (location != null) {
                                      from_search = location;
                                      fromSearchbar.currentState.updateText(from_search.location.name + (from_search.location.place != null ? ", " + from_search.location.place : ""));
                                    } else {
                                      fromSearchbar.currentState.updateText("Start");
                                    }
                                  },
                                ),
                                Searchbar(
                                  key: toSearchbar,
                                  text: "Ziel",
                                  onTap: () async {
                                    SuggestedLocation location = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchInputPageWide(data: dataMode)));
                                    if (location != null) {
                                      to_search = location;
                                      toSearchbar.currentState.updateText(to_search.location.name + (to_search.location.place != null ? ", " + to_search.location.place : ""));
                                    } else {
                                      toSearchbar.currentState.updateText("Ziel");
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: _selectTime,
                                        child: Chip(
                                          elevation: 2,
                                          avatar: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            child: Icon(Icons.access_time, size: 20, color: Colors.white),
                                          ),
                                          label: Text(
                                            setup_time.hour.toString() + ":" + setup_time.minute.toString().padLeft(2, '0'),
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
                                          ),
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      InkWell(
                                        onTap: _selectDate,
                                        child: Chip(
                                          elevation: 2,
                                          avatar: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            child: Icon(MaterialCommunityIcons.calendar_search, size: 20, color: Colors.white),
                                          ),
                                          label: Text(
                                            setup_date.day.toString().padLeft(2, '0') + "." + setup_date.month.toString().padLeft(2, '0') + "." + setup_date.year.toString().padLeft(4, '0'),
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
                                          ),
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.04,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.search, color: Colors.white),
                                    onPressed: () {
                                      if (from_search == null) return;
                                      if (to_search == null) return;
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultPageWide(
                                        from_search: from_search,
                                        to_search: to_search,
                                        time: setup_time,
                                        date: setup_date,
                                        barrier: _barrier,
                                        fastroute: _fastestRoute,
                                        slowwalk: _slow,
                                        products: generateLimterString(),
                                      )));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.29,
                            height: MediaQuery.of(context).size.height * 0.40,
                            child: Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  Divider(
                                    height: 1,
                                    color: Colors.white,
                                    thickness: 0.5,
                                  ),
                                  AdvancedSwitchListTile(
                                    key: fastestRouteSwitch,
                                    leadingIcon: Icon(Icons.fast_forward, color: Colors.white),
                                    onChanged: (bool value) {
                                      fastestRouteSwitch.currentState.updateSwitch(value);
                                      _fastestRoute = value;
                                    },
                                    defaultValue: _fastestRoute,
                                    title: Text(
                                      "Schnellste Route",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  AdvancedSwitchListTile(
                                    key: barrierSwitch,
                                    leadingIcon: Icon(Icons.accessible_forward, color: Colors.white),
                                    onChanged: (bool value) {
                                      barrierSwitch.currentState.updateSwitch(value);
                                      _barrier = value;
                                    },
                                    defaultValue: _barrier,
                                    title: Text(
                                      "Barrierefreiheit",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  AdvancedSwitchListTile(
                                    key: slowSwitch,
                                    leadingIcon: Icon(Icons.timelapse, color: Colors.white),
                                    onChanged: (bool value) {
                                      slowSwitch.currentState.updateSwitch(value);
                                      _slow = value;
                                    },
                                    defaultValue: _slow,
                                    title: Text(
                                      "Längere Umsteigezeit",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                  AdvancedListTile(
                                    leadingIcon: Icon(Icons.train, color: Colors.white),
                                    title: Text(
                                      "Verkehrsmittel",
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                    onTap: () {
                                      showDataDialog();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }

  Future _selectTime() async {
    TimeOfDay selectedTime24Hour = await showTimePicker(
      context: context,
      initialTime: setup_time,
      builder: (BuildContext context, Widget child) {
        return ShowUp(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          ),
        );
      },
    );

    if (selectedTime24Hour != null)
      setup_time = selectedTime24Hour;
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: setup_date,
      firstDate: new DateTime(2019),
      lastDate: new DateTime(2020),
      builder: (BuildContext context, Widget child) {
        return ShowUp(
          child: MediaQuery(
            data: MediaQuery.of(context),
            child: child,
          ),
        );
      },
    );

    if (picked != null)
      setup_date = picked;
  }

  void showDataDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowUp(
            child: AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                  "Verkehrsmittel",
                  style: TextStyle(
                    color: Colors.white
                  ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)
              ),
              content: SizedBox(
                width: MediaQuery.of(this.context).size.width * 0.40,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: highspeedSwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.train, color: Colors.white),
                      onChanged: (bool value) {
                        highspeed = value;
                        highspeedSwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "ICE/IC/EC",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: regionalSwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.train_variant, color: Colors.white),
                      onChanged: (bool value) {
                        regional = value;
                        regionalSwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "IRE/RE/RB",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: suburbanSwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.subway_variant, color: Colors.white),
                      onChanged: (bool value) {
                        suburban = value;
                        suburbanSwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "S-Bahn",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: subwaySwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.subway, color: Colors.white),
                      onChanged: (bool value) {
                        subway = value;
                        subwaySwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "U-Bahn",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: busSwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.bus, color: Colors.white),
                      onChanged: (bool value) {
                        bus = value;
                        busSwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "Bus",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: tramSwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.tram, color: Colors.white),
                      onChanged: (bool value) {
                        tram = value;
                        tramSwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "Straßenbahn",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: ferrySwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.ferry, color: Colors.white),
                      onChanged: (bool value) {
                        ferry = value;
                        ferrySwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "Fähre",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AdvancedSwitchListTile(
                      key: ondemandSwitch,
                      leadingIcon: Icon(MaterialCommunityIcons.train_car, color: Colors.white),
                      onChanged: (bool value) {
                        ondemand = value;
                        ondemandSwitch.currentState.updateSwitch(value);
                      },
                      defaultValue: highspeed,
                      title: Text(
                        "AST/Ruftaxi",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Schließen", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  String generateLimterString() {
    String generated = "";

    if (highspeed == true) {
      generated += "HIGH_SPEED_TRAIN,";
    }
    if (regional == true) {
      generated += "REGIONAL_TRAIN,";
    }
    if (suburban == true) {
      generated += "SUBURBAN_TRAIN,";
    }
    if (subway == true) {
      generated += "SUBWAY,";
    }
    if (bus == true) {
      generated += "BUS,";
    }
    if (tram == true) {
      generated += "TRAM,";
    }
    if (ferry == true) {
      generated += "FERRY,";
    }
    if (ondemand == true) {
      generated += "ON_DEMAND";
    }

    if (generated == "") {
      generated += "HIGH_SPEED_TRAIN,";
      generated += "REGIONAL_TRAIN,";
      generated += "SUBURBAN_TRAIN,";
      generated += "SUBWAY,";
      generated += "BUS,";
      generated += "TRAM,";
      generated += "FERRY,";
      generated += "ON_DEMAND";
    }

    return generated;
  }
}