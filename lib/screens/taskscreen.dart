import 'package:flutter/material.dart';
import 'package:todotrack/values/contants.dart';
import 'package:todotrack/widgets/widgets.dart';
class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLiteColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.arrow_back,
                              color: kPrimaryColor,
                            ),
                            onTap: (){
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter Task Title ",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  color: kPrimaryColor, fontWeight: FontWeight.w900),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the description of your task...",
                          hintStyle: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 12.0, color: kPrimaryColor),
                      ),
                    ),
                    TodoWidget(
                      title: "Doing something",
                      isDone: true,
                    ),
                    TodoWidget(
                      title: "Making a list",
                      isDone: true,
                    ),
                    TodoWidget(
                      title: "addning element to list",
                      isDone: false,
                    ),



                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: kDarkColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: kLiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
