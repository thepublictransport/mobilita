import 'package:flutter/material.dart';
import 'package:mobilita/animations/Marquee.dart';
import 'package:mobilita/tools/UnixTimeParser.dart';
import 'package:mobility_framework/backend/models/main/Leg.dart';
import 'package:mobility_framework/backend/models/main/Stop.dart';
import 'package:mobility_framework/backend/models/main/Trip.dart';

class ResultDetailedPageGeneralWide extends StatefulWidget {

  final Trip trip;

  const ResultDetailedPageGeneralWide({Key key, this.trip}) : super(key: key);

  @override
  _ResultDetailedPageGeneralWideState createState() => _ResultDetailedPageGeneralWideState(this.trip);
}

class _ResultDetailedPageGeneralWideState extends State<ResultDetailedPageGeneralWide> {

  final Trip trip;

  _ResultDetailedPageGeneralWideState(this.trip);

  DateTime begin;
  DateTime end;
  Duration diff;
  String diffString;

  @override
  void initState() {
    begin = UnixTimeParser.parse(trip.firstDepartureTime);
    end = UnixTimeParser.parse(trip.lastArrivalTime);
    diff = difference(begin, end);
    diffString ="${diff.inHours}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}";
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
              Icon(Icons.train, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                  trip.from.name + " -> " + trip.to.name
              )
            ],
          )
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        height: double.infinity,
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
    if (leg.line == null) {
      var begin = UnixTimeParser.parse(leg.departureTime);
      var end = UnixTimeParser.parse(leg.arrivalTime);
      var difference = end.difference(begin);

      return Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(23, 20, 23, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                difference.inMinutes.remainder(60).toString() + " " + "Minuten Umsteigezeit",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        getDelay(leg.departureTime, leg.departureDelay),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Marquee(
                            direction: Axis.horizontal,
                            child: Text(
                              leg.departure.name,
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
                    Text(
                      leg.departurePosition != null ? "Gl." + " " + leg.departurePosition.name : "",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: Colors.black
                      ),
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
                        Icon(getIcon(leg.line.product), color: Colors.black),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(leg.line.name, style: TextStyle(color: Colors.black)),
                            Text(leg.destination.name, style: TextStyle(color: Colors.black))
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              leg.message == null ? Icons.check : Icons.warning,
                              color: leg.message == null ? Colors.grey : Colors.red,
                            ),
                            onPressed: leg.message == null ? null : () {
                              _showMessage(leg.message);
                            }
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.more,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _showIntermediateStops(leg.intermediateStops);
                            }
                        ),
                      ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        getDelay(leg.arrivalTime, leg.arrivalDelay),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Marquee(
                            direction: Axis.horizontal,
                            child: Text(
                              leg.arrival.name,
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
                    Text(
                      leg.arrivalPosition != null ? "Gl." + " " + leg.arrivalPosition.name : "",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NunitoSansBold',
                          color: Colors.black
                      ),
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
        createTimeCard(leg, futureLeg)
      ],
    );
  }

  Widget getDelay(int currentTime, int currentDelay) {
    var time = UnixTimeParser.parse(currentTime);

    if (currentDelay != null) {
      var time_delay = UnixTimeParser.parse(currentTime + currentDelay);

      return Column(
        children: <Widget>[
          Text(
            time.hour.toString().padLeft(2, '0') + ":" + time.minute.toString().padLeft(2, '0') + "  ",
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'NunitoSansBold'
            ),
          ),
          Text(
            time_delay.hour.toString().padLeft(2, '0') + ":" + time_delay.minute.toString().padLeft(2, '0') + "  ",
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'NunitoSansBold',
                color: Colors.red
            ),
          ),
        ],
      );
    }

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

  createTimeCard(Leg leg, Leg futureLeg) {

    if (futureLeg == null)
      return Container();

    var begin = UnixTimeParser.parse(leg.arrivalTime + (leg.arrivalDelay != null ? leg.arrivalDelay : 0));
    var end = UnixTimeParser.parse(futureLeg.departureTime + (futureLeg.departureDelay != null ? futureLeg.departureDelay : 0));
    var difference = end.difference(begin);

    if (futureLeg.line == null)
      return Container();

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
          title: new Text("Benachrichtigung", style: TextStyle(color: Colors.black)),
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

  void _showIntermediateStops(List<Stop> stops) {
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
          title: new Text("Zwischenhalte", style: TextStyle(color: Colors.black)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: stops.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.location_on, color: Colors.black),
                  title: Text(
                    stops[index].location.name,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  trailing: SizedBox(
                    height: 50,
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        getIntermediateDelay(stops[index].departureTime, stops[index].departureDelay),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
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

  getIntermediateDelay(int currentTime, int currentDelay) {
    var time = UnixTimeParser.parse(currentTime);

    if (currentDelay != null) {
      var time_delay = UnixTimeParser.parse(currentTime + currentDelay);

      return Column(
        children: <Widget>[
          Text(
            time.hour.toString().padLeft(2, '0') + ":" + time.minute.toString().padLeft(2, '0') + "  ",
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'NunitoSansBold'
            ),
          ),
          Text(
            time_delay.hour.toString().padLeft(2, '0') + ":" + time_delay.minute.toString().padLeft(2, '0') + "  ",
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'NunitoSansBold',
                color: Colors.red
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Text(
          time.hour.toString().padLeft(2, '0') + ":" + time.minute.toString().padLeft(2, '0') + "  ",
          style: TextStyle(
              fontSize: 15,
              fontFamily: 'NunitoSansBold'
          ),
        ),
        Text(
          time.hour.toString().padLeft(2, '0') + ":" + time.minute.toString().padLeft(2, '0') + "  ",
          style: TextStyle(
              fontSize: 15,
              fontFamily: 'NunitoSansBold',
              color: Colors.green
          ),
        ),
      ],
    );
  }
}
