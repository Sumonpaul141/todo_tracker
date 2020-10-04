import 'package:flutter/material.dart';
import 'package:todotrack/values/contants.dart';

class TodoWidget extends StatelessWidget {
  final bool isDone;
  final String title;
  final String dateTime;

  const TodoWidget(
      {Key key, @required this.isDone, this.title, this.dateTime})
      : super(key: key);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title == null ? "Empty Todo" : title,
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? kDarkColor.withOpacity(0.5) : kPrimaryColor,
                    fontSize: isDone ? 14.0 : 14.0,
                    fontWeight: isDone? null : FontWeight.w600,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Visibility(
                  visible: dateTime != null,
                  child: Text(
                    dateTime == null ? "No deadline" : "Time "+ dateTime.substring(11, 16),
                    style: TextStyle(
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: kDarkColor.withOpacity(0.6),
                      fontSize: 10.0,
                    ),
                  ),
                ),
                Visibility(
                  visible: dateTime != null,
                  child: Text(
                    dateTime == null ? "No deadline" : "Date "+ dateTime.substring(0, 10),
                    style: TextStyle(
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: kDarkColor.withOpacity(0.6),
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ],
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
