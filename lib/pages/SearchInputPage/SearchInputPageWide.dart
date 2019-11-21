import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobility_framework/backend/models/main/SuggestedLocation.dart';
import 'package:mobility_framework/backend/service/core/CoreService.dart';

class SearchInputPageWide extends StatefulWidget {
  final String data;

  const SearchInputPageWide({Key key, this.data}) : super(key: key);

  @override
  _SearchInputPageWideState createState() => _SearchInputPageWideState();
}

class _SearchInputPageWideState extends State<SearchInputPageWide> {
  TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search, color: Colors.white),
            SizedBox(
              width: 10,
            ),
            Text(
              "Suche"
            )
          ],
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).padding.top + 10, 5, 0),
            child: Card(
              color: Colors.black,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: TypeAheadFormField(
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _typeAheadController,
                    autofocus: false,
                    autocorrect: true,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      hintText: "Suche nach Haltestelle...",
                      hintStyle: TextStyle(
                          color: Colors.white
                      ),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                    )
                ),
                suggestionsCallback: (pattern) async {
                  var test = await getResults(pattern);
                  return test;
                },
                itemBuilder: (context, suggestion) {
                  return Container(
                    color: Colors.black,
                    child: ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title: Text(
                        suggestion.location.name + (suggestion.location.place != null ? ", " + suggestion.location.place : ""),
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (SuggestedLocation suggestion) async {
                  Navigator.pop(context, suggestion);
                },
              ),
            ),
          ),
          /*Container(
            padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).padding.top + 10, 5, 0),
            alignment: Alignment.center,
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Haltestelle in ihrer Nähe benutzen",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),
              )
            )
          )*/
        ],
      ),
    );
  }

  Future<List<SuggestedLocation>> getResults(String query) async {
    var result = await CoreService.getLocationQuery(query, "STATION", 10.toString(), widget.data);

    return result.suggestedLocations;
  }
}
