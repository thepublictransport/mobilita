import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mobilita/pages/ResultDetailedPages/ResultDetailedPageFlixbusWide.dart';
import 'package:mobilita/pages/ResultDetailedPages/ResultDetailedPageGeneralWide.dart';
import 'package:mobilita/tools/DateParser.dart';
import 'package:mobilita/tools/DurationParser.dart';
import 'package:mobilita/tools/UnixTimeParser.dart';
import 'package:mobility_framework/backend/models/core/FlixbusJourneyModel.dart';
import 'package:mobility_framework/backend/models/core/SparpreisFinderModel.dart';
import 'package:mobility_framework/backend/models/core/TripModel.dart';
import 'package:mobility_framework/backend/models/flixbus/Message.dart';
import 'package:mobility_framework/backend/models/sparpreis/Message.dart' as sparpreis;
import 'package:mobility_framework/backend/models/main/SuggestedLocation.dart';
import 'package:mobility_framework/backend/models/main/Trip.dart';
import 'package:mobility_framework/backend/service/core/CoreService.dart';
import 'package:mobility_framework/mobility_framework.dart';

class ResultPageWide extends StatefulWidget {
  final SuggestedLocation from_search;
  final SuggestedLocation to_search;
  final TimeOfDay time;
  final DateTime date;
  final bool barrier;
  final bool slowwalk;
  final bool fastroute;
  final String products;

  const ResultPageWide({Key key, this.from_search, this.to_search, this.time, this.date, this.barrier, this.slowwalk, this.fastroute, this.products}) : super(key: key);

  @override
  _ResultPageWideState createState() => _ResultPageWideState(this.from_search, this.to_search, this.time, this.date, this.barrier, this.slowwalk, this.fastroute, this.products);
}

class _ResultPageWideState extends State<ResultPageWide> {
  final SuggestedLocation from_search;
  final SuggestedLocation to_search;
  final TimeOfDay time;
  final DateTime date;
  final bool barrier;
  final bool slowwalk;
  final bool fastroute;
  final String products;

  _ResultPageWideState(this.from_search, this.to_search, this.time, this.date, this.barrier, this.slowwalk, this.fastroute, this.products);


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.train),
                text: "Generell",
              ),
              Tab(
                icon: Icon(Icons.directions_bus),
                text: "Flixbus",
              ),
              Tab(
                  icon: Icon(Icons.monetization_on),
                  text: "Sparpreis",
              ),
            ],
          ),
          title: Text('Suchergebnisse'),
        ),
        body: TabBarView(
          children: [
            createGeneral(),
            createFlixbus(),
            createSparpreis()
          ],
        ),
      ),
    );
  }

  Widget createGeneral() {
    return FutureBuilder(
        future: getTrips(),
        builder: (BuildContext context, AsyncSnapshot<TripModel> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: CircularProgressIndicator(
                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(snapshot.error);
              } else {
                if (snapshot.data.trips == null) {
                  return Container(
                    child: Center(
                      child: Text("Leider ist die Suche fehlgeschlagen.", style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.trips.length,
                    itemBuilder: (BuildContext context, int index) {
                      return createGeneralCard(snapshot.data.trips[index]);
                    }
                );
              }
          }
          return null;
        }
    );
  }

  Widget createGeneralCard(Trip trip) {
    final _parentKey = GlobalKey();
    var begin = UnixTimeParser.parse(trip.firstDepartureTime);
    var end = UnixTimeParser.parse(trip.lastArrivalTime);
    var difference = DurationParser.parse(end.difference(begin));
    var travels = [];
    var counter = 0;

    for (var i in trip.legs) {
      if (i.line == null)
        continue;

      travels.add(i.line.name.replaceAll(new RegExp("[^A-Za-z]+"), ""));
      counter++;
    }


    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        key: _parentKey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultDetailedPageGeneralWide(trip: trip)));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      begin.hour.toString().padLeft(2, '0') + ":" + begin.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: Colors.black
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      end.hour.toString().padLeft(2, '0') + ":" + end.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: Colors.black
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      difference,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: Colors.black
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      counter.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 2.0,
                ),
                Text(
                  travels.join(" - "),
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'NunitoSansBold',
                      color: Colors.black
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<TripModel> getTrips() async {
    String barrier_mode = barrier == true ? "BARRIER_FREE" : "NEUTRAL";
    String slowwalk_mode = slowwalk == true ? "SLOW" : "NORMAL";
    String fastroute_mode = fastroute == true ? "LEAST_DURATION" : "LEAST_CHANGES";

    return CoreService.getTripById(
        from_search.location.id,
        to_search.location.id,
        DateParser.getTPTDate(date, time),
        barrier_mode,
        fastroute_mode,
        slowwalk_mode,
        "DB",
        products
    );
  }

  Widget createFlixbus() {
    return FutureBuilder(
        future: getJourney(),
        builder: (BuildContext context, AsyncSnapshot<FlixbusJourneyModel> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: CircularProgressIndicator(

                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(snapshot.error);
              } else {
                if (snapshot.data.message == null) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text("Zu ihrer Suche gibt es leider keine Flixbus Reisen", style: TextStyle(color: Colors.grey)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Zu ihrer Suche gibt es leider keine Flixbus Reisen")
                      ],
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.message.length,
                    itemBuilder: (BuildContext context, int index) {
                      return createFlixbusCard(snapshot.data.message[index]);
                    }
                );
              }
          }
          return null;
        }
    );
  }

  Widget createFlixbusCard(Message message) {
    var begin = message.legs.first.departure;
    var end = message.legs.last.arrival;
    var difference = DurationParser.parse(end.difference(begin));
    final _parentKey = GlobalKey();

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultDetailedPageFlixbusWide(trip: message)));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          begin.hour.toString().padLeft(2, '0') + ":" + begin.minute.toString().padLeft(2, '0'),
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NunitoSansBold',
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          end.hour.toString().padLeft(2, '0') + ":" + end.minute.toString().padLeft(2, '0'),
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NunitoSansBold',
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          difference,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NunitoSansBold',
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          message.legs.length.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),
                      ],
                    ),
                    Text(
                      message.price.amount.toString() + " " + message.price.currency.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: expensiveColor(message.price.amount)
                      ),
                    )
                  ],
                ),
                Divider(
                  height: 2.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Start: ",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                      ),
                    ),
                    Text(
                      message.legs.first.origin.name,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Ziel: ",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black
                      ),
                    ),
                    Text(
                      message.legs.last.destination.name,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: Colors.black
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color expensiveColor(double amount) {
    if (amount > 41)
      return Colors.red;

    return Colors.green;
  }

  Future<FlixbusJourneyModel> getJourney() async {
    var flixFromID = await FlixbusService.getDBToFlix(from_search.location.id);
    var flixToID = await FlixbusService.getDBToFlix(to_search.location.id);
    return FlixbusService.getJourney(flixFromID.message.first.id, flixFromID.message.first.type, flixToID.message.first.id, flixToID.message.first.type, DateParser.getRFCDate(date, time));
  }

  Widget createSparpreis() {
    return FutureBuilder(
        future: getSparpreise(),
        builder: (BuildContext context, AsyncSnapshot<SparpreisFinderModel> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: SizedBox(
                  width: 500,
                  height: 500,
                  child: CircularProgressIndicator(

                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(snapshot.error);
              } else {
                if (snapshot.data.message == null) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text("Leider konnte für ihre Suche kein Sparpreis gefunden werden.", style: TextStyle(color: Colors.grey)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Leider konnte für ihre Suche kein Sparpreis gefunden werden.")
                      ],
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.message.length,
                    itemBuilder: (BuildContext context, int index) {
                      return createSparpreisCard(snapshot.data.message[index]);
                    }
                );
              }
          }
          return null;
        }
    );
  }

  Widget createSparpreisCard(sparpreis.Message message) {
    var begin = message.legs.first.departure;
    var end = message.legs.last.arrival;
    var difference = DurationParser.parse(end.difference(begin));
    var travels = [];
    var counter = 0;

    for (var i in message.legs) {
      if (i.line == null)
        continue;

      travels.add(i.line.name.replaceAll(new RegExp("[^A-Za-z]+"), ""));
      counter++;
    }


    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            getDBPage(message);
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          begin.hour.toString().padLeft(2, '0') + ":" + begin.minute.toString().padLeft(2, '0'),
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NunitoSansBold',
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          end.hour.toString().padLeft(2, '0') + ":" + end.minute.toString().padLeft(2, '0'),
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NunitoSansBold',
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          difference,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NunitoSansBold',
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          counter.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),
                      ],
                    ),
                    Text(
                      message.price.amount.toString() + "0 " + message.price.currency.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: expensiveColor(message.price.amount)
                      ),
                    )
                  ],
                ),
                Divider(
                  height: 2.0,
                ),
                Text(
                  travels.join(" - "),
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'NunitoSansBold',
                      color: Colors.black
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<SparpreisFinderModel> getSparpreise() async {
    return SparpreisService.getSparpreise(from_search.location.id, to_search.location.id, DateParser.getRFCDate(date, time));
  }

  getDBPage(sparpreis.Message message) async {
    var url = 'https://link.bahn.guru/?journey=' + message.toRawJson() + '&bc=0&class=2';

    html.window.open(url, "Sparpreis");
  }
}
