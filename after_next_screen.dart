
import 'package:flutter/material.dart';
import 'package:pikaaya/next_screen_of_otp.dart';
import 'package:pikaaya/create_account.dart';

class AfterNextScreen extends StatefulWidget {
  const AfterNextScreen({Key? key}) : super(key: key);

  @override
  State<AfterNextScreen> createState() => _SubmitDocumentState();
}

class _SubmitDocumentState extends State<AfterNextScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NextScreenOfOtp(),
                ));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top:200),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success Icon
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 40),

            // Verification Text
            Text(
              "You are Successfully verified",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            // Additional Text
            Text(
              "Your Account is Verified\nLet's Start",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder:  (context)=>CreateAccount(),
                  ));
                },
                child: Text(
                  "CREATE ACCOUNT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
