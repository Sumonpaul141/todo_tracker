import 'package:flutter/material.dart';
import 'package:todotrack/values/contants.dart';

class LoginPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            height: height * 0.3,
            color: kPrimaryColor,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Image(
                  height: 60.0,
                  width: 60.0,
                  image: AssetImage(
                    'images/todologo.png'
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.22,
            left: width * 0.1,
            right: width * 0.1,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  width: width * 0.8,
                  height: height * 0.5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30.0,),
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            color: kPrimaryColor,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email ID",
                            hintMaxLines: 2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            color: kPrimaryColor,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintMaxLines: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight:  Radius.circular(25.0),),
                    ),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
          Positioned(
            top: height * 0.8,
            right: 0,
            left: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.1),
              height: 60.0,
              decoration: BoxDecoration(
                color: kLiteColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Text(
                  "Registration",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
