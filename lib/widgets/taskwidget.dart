import 'package:flutter/material.dart';
import 'package:todotrack/values/contants.dart';

class TaskWidget extends StatelessWidget {
  final String title, desc;

  const TaskWidget({
    Key key,
    this.title,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                boxShadow: [BoxShadow(
                    offset: Offset(5,5),
                    blurRadius: 2.0,
                    color: kDarkColor.withOpacity(0.2)
                )]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical : 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
                  ),
                  child: Text(
                    title != null ? title : "Undefined title",
                    maxLines: 1,
                    style: TextStyle(
                      color: kLiteColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    desc == null || desc == "" ? "No description added!!" : desc,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 12.0,
                    ),
                    maxLines: 4,
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}