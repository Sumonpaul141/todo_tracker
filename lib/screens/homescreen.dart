import 'package:flutter/material.dart';
import 'package:todotrack/values/contants.dart';
import 'package:todotrack/widgets/widgets.dart';
import 'package:todotrack/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLiteColor,
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
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage("images/todologo.png"),
                            height: 60.0,
                            width: 60.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            kAppName,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w900),
                          )
                        ],
                      ),
                      AllTodos(
                        title: "Get Start",
                        desc:
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
                      ),
                      AllTodos(),
                      AllTodos(),
                      AllTodos(),
                      AllTodos(),
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
