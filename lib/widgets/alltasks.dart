import 'package:flutter/material.dart';
import 'package:todotrack/values/contants.dart';

class AllTasks extends StatelessWidget {
  final String title, desc;

  const AllTasks({
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title != null ? title : "Undefined title",
                    maxLines: 1,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    desc != null ? desc : "For this todo you forget to add a description, so this is not showing, you can add a description, or leave as it is",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 12.0,
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}