import 'package:flutter/material.dart';
import 'package:mobilita/animations/Marquee.dart';
import 'package:mobility_framework/backend/models/flixbus/Leg.dart';
import 'package:mobility_framework/backend/models/flixbus/Message.dart';

class ResultDetailedPageFlixbusWide extends StatefulWidget {

  final Message trip;

  const ResultDetailedPageFlixbusWide({Key key, this.trip}) : super(key: key);

  @override
  _ResultDetailedPageFlixbusWideState createState() => _ResultDetailedPageFlixbusWideState(this.trip);
}

class _ResultDetailedPageFlixbusWideState extends State<ResultDetailedPageFlixbusWide> {

  final Message trip;

  _ResultDetailedPageFlixbusWideState(this.trip);

  DateTime begin;
  DateTime end;
  Duration diff;
  String diffString;

  @override
  void initState() {
    begin = trip.legs.first.departure;
    end = trip.legs.last.arrival;
    diff = difference(begin, end);
    diffString ="${diff.inHours}:${diff.inMinutes.remainder(60)}";
    super.initState();
  }

  Duration difference(DateTime begin, DateTime end) {
    return end.difference(begin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.directions_bus, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                  "Flixbus"
              )
            ],
          )
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        height: double.infinity,
        color: Colors.white,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: trip.legs.length,
            itemBuilder: (BuildContext context, int index) {
              return createCard(trip.legs[index], index + 1 != trip.legs.length ? trip.legs[index + 1] :  null);
            }
        ),
      ),
    );
  }

  Widget createCard(Leg leg, Leg futureLeg) {
    if (leg.legOperator == null) {
      var begin = leg.departure;
      var end = leg.arrival;
      var difference = end.difference(begin);

      return Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(23, 20, 23, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                difference.inMinutes.toString() + " " + "Minuten Umsteigezeit",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'NunitoSansBold',
                    color: Colors.black
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0)
          ),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        getTime(leg.departure),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Marquee(
                            direction: Axis.horizontal,
                            child: Text(
                              leg.origin.name,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'NunitoSansBold',
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 2.0,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.directions_bus, color: Colors.black),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Flixbus", style: TextStyle(color: Colors.black)),
                            Text(leg.destination.name, style: TextStyle(color: Colors.black))
                          ],
                        )
                      ],
                    ),
                    IconButton(
                        icon: Icon(
                          trip.info.message == null ? Icons.check : Icons.warning,
                          color: trip.info.message == null ? Colors.grey : Colors.red,
                        ),
                        onPressed: trip.info.message == null ? null : () {
                          _showMessage(trip.info.message);
                        }
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 2.0,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        getTime(leg.arrival),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Marquee(
                            direction: Axis.horizontal,
                            child: Text(
                              leg.destination.name,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'NunitoSansBold',
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getTime(DateTime time) {
    return Text(
      time.hour.toString().padLeft(2, '0') + ":" + time.minute.toString().padLeft(2, '0') + "  ",
      style: TextStyle(
          fontSize: 15,
          fontFamily: 'NunitoSansBold',
          color: Colors.black
      ),
    );
  }

  IconData getIcon(String vehicle) {
    print(vehicle);
    switch (vehicle) {
      case "HIGH_SPEED_TRAIN":
      case "REGIONAL_TRAIN":
      case "SUBURBAN_TRAIN":
        return Icons.train;
      case "BUS":
        return Icons.directions_bus;
      case "TRAM":
        return Icons.tram;
      default:
        return Icons.train;
    }
  }

  void _showMessage(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0)
          ),
          backgroundColor: Colors.white,
          title: new Text("Benachrichtigungen", style: TextStyle(color: Colors.black)),
          content: new Text(message != null ? message : "Keine Benachrichtigungen", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Schließen", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
