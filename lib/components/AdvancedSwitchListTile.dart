import 'package:flutter/material.dart';

class AdvancedSwitchListTile extends StatefulWidget {

  final ValueChanged<bool> onChanged;
  final bool defaultValue;
  final Text title;
  final Text subtitle;
  final Icon leadingIcon;

  AdvancedSwitchListTile({Key key, this.onChanged, this.defaultValue, this.title, this.subtitle, this.leadingIcon}) : super(key: key);

  @override
  AdvancedSwitchListTileState createState() => AdvancedSwitchListTileState();
}

class AdvancedSwitchListTileState extends State<AdvancedSwitchListTile> {

  var value = false;

  @override
  void initState() {
    value = widget.defaultValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10),
            height: 20,
            width: 50,
            child: Center(child: widget.leadingIcon == null ? Container() : widget.leadingIcon)
        ),
        Flexible(
          child: SwitchListTile(
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withAlpha(90),
            inactiveTrackColor: Colors.white.withAlpha(40),
            onChanged: widget.onChanged,
            value: value,
            title: widget.title,
            subtitle: widget.subtitle,
          ),
        ),
      ],
    );
  }

  updateSwitch(bool changed) {
    setState(() {
      value = changed;
    });
  }
}
