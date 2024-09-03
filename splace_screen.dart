import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pikaaya/phoneno_screen.dart';
import 'package:pikaaya/main.dart';

class SplaceScreen extends StatefulWidget {
  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyPhone(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(

        children: [


          Container(

            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff2d135b),
                    Color(0xffcc208e),
                    Color(0xff721424)],
                  begin: FractionalOffset(1.0, 0.2),
                  end: FractionalOffset(0.0, 1.1)),
            ),

            child: Center(
              heightFactor: 700,
              widthFactor: 700,
              child: Image.asset('assets/Images/deli.png'),

            ),



          ),

          Container(
           margin:EdgeInsets.fromLTRB(130, 170, 50, 0),
            child: Image.asset('assets/Images/logoofpikaaya.png'),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(100,640,50,0),
            child: Text(
              'A Whole Grocery Store\n    at your Fingertips',
              style: TextStyle(color: Colors.white, fontSize: 20 ),
            ),
          ),
        ],
      )
    );
  }
}
