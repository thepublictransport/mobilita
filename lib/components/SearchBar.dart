import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  Searchbar({Key key, this.text, this.onTap, this.onButtonPressed}) : super(key: key);

  final String text;
  final Function onTap;
  final Function onButtonPressed;

  @override
  SearchbarState createState() => SearchbarState();
}

class SearchbarState extends State<Searchbar> {

  var text = "";

  @override
  void initState() {
    text = widget.text;
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Card(
        shape: new StadiumBorder(
            side: new BorderSide(width: 0, color: Colors.transparent)
        ),
        elevation: 2,
        color: Colors.black,
        child: SizedBox(
            height: 50,
            child: InkWell(
              onTap: widget.onTap,
              child: new Container(
                  padding: EdgeInsets.only(left: 17),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(text,
                          overflow: TextOverflow.fade,
                          style: new TextStyle(
                              fontSize: 17,
                              color: Colors.white)),
                      new Container(
                        child: IconButton(
                            icon: Icon(Icons.my_location,
                                color: Colors.white),
                            onPressed: widget.onButtonPressed),
                      )
                    ],
                  )
              ),
            )
        )
    );
  }

  updateText(String updatedText) {
    setState(() {
      text = updatedText;
    });
  }
}