import 'package:flutter/material.dart';
import 'package:todotrack/values/contants.dart';

class TodoWidget extends StatelessWidget {
  final bool isDone;
  final String title;
  const TodoWidget({Key key, @required this.isDone, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: isDone ? kPrimaryColor : kLiteColor,
              borderRadius: BorderRadius.circular(10.0),
              border: !isDone
                  ? Border.all(
                style: BorderStyle.solid,
                color: kDarkColor.withOpacity(0.4),
              )
                  : null,
            ),
            child: Icon(
              isDone ? Icons.done : null,
              color: kLiteColor,
              size: 15.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              title == null ? "Empty Todo" : title,
              style: TextStyle(
                color: isDone ?  kPrimaryColor : kDarkColor.withOpacity(0.6),
                fontSize: isDone ? 15.0: 14.0,
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }
}