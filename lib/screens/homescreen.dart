import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todotrack/models/models.dart';
import 'package:todotrack/utils/database.dart';
import 'package:todotrack/values/contants.dart';
import 'package:todotrack/widgets/widgets.dart';
import 'package:todotrack/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseManager databaseManager;
  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    databaseManager = DatabaseManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLiteColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          children: <Widget>[
//            Container(
//              margin: EdgeInsets.symmetric(horizontal: 10.0),
//              padding: EdgeInsets.all(5.0),
//              height: 50.0,
//              width: 50.0,
//              decoration: BoxDecoration(
//                color: kWhiteColor,
//                borderRadius: BorderRadius.circular(30.0),
//              ),
//              child: Image(
//                image: AssetImage("images/todologo.png"),
//              ),
//            ),
            SizedBox(width: 10.0,),
            Text(
              "{ " + kAppName + " }",
              style: TextStyle(
                  color: kLiteColor, fontSize: 22.0, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Stack(
            children: <Widget>[
              ScrollConfiguration(
                behavior: NoGlowBehaviour(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          Image(
//                            image: AssetImage("images/todologo.png"),
//                            height: 60.0,
//                            width: 60.0,
//                          ),
//                          SizedBox(
//                            width: 20.0,
//                          ),
//                          Text(
//                            "{ " + kAppName + " }",
//                            style: TextStyle(
//                                color: kPrimaryColor,
//                                fontSize: 22.0,
//                                fontWeight: FontWeight.w900),
//                          )
//                        ],
//                      ),
                      FutureBuilder(
                        future: databaseManager.getAllTasks(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Task> taskList = snapshot.data;
                            if(taskList.length == 0){
                              return Center(
                                child: Container(
                                  height: 300.0,
                                  width: 200.0,
                                  child: Center(
                                    child: Text(
                                      "No task / project available... \nYou can add one and start creating your list..\nPress the (+) button to add",
                                      style: TextStyle(
                                        color: kDarkColor.withOpacity(0.5),
                                        fontSize: 15.0
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }else{
                              return Container(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: taskList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TaskScreen(
                                                task: taskList[index],
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: TaskWidget(
                                          title: taskList[index].taskTitle,
                                          desc: taskList[index].taskDescription,
                                        ),
                                      );
                                    },
                                  ));
                            }

                          } else if (snapshot.hasError) {
                            return Container(
                              child: Text(snapshot.error),
                            );
                          } else {
                            return Container(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskScreen(
                          task: null,
                        ),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: kDarkColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Icon(
                      Icons.add,
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
