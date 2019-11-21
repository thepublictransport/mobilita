import 'package:flutter/material.dart';

class AdvancedListTile extends StatelessWidget {

  final Function onTap;
  final Text title;
  final Text subtitle;
  final Icon leadingIcon;

  AdvancedListTile({this.onTap, this.title, this.subtitle, this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10),
              height: 20,
              width: 50,
              child: Center(child: leadingIcon == null ? Container() : leadingIcon)
          ),
          Flexible(
            child: ListTile(
              title: title,
              subtitle: subtitle,
            ),
          ),
        ],
      ),
    );
  }
}
