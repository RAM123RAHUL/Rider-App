import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pikaaya/next_screen_of_otp.dart';
import 'package:pikaaya/phoneno_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late List<TextEditingController> otpControllers;
  late Timer _timer;
  int _start = 30; // Countdown timer start value in seconds
  bool _isResendEnabled = false; // Controls the "Resend" button state

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(4, (index) => TextEditingController());
    _startTimer();
  }

  @override
  void dispose() {
    otpControllers.forEach((controller) => controller.dispose());
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _start = 30; // Reset the timer
    _isResendEnabled = false; // Disable "Resend" button
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true; // Enable "Resend" button when timer reaches 0
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }


  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }


//Token Number
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }



  //Mobile Number
  Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone_number');
  }












  Future<void> _verifyOtp() async {





      final token = await getToken();
      print('Retrieved token: $token');

    final mobile=await getPhoneNumber();
    print('Retrieved Mobile:$mobile');



      final url = Uri.parse(
          'https://pikaaya.com/development/developmentHottrix/api/delivery_otp_verify'); // Example URL
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({

          "phone_number":mobile,

          "token": token,
          // Replace with actual token
          "otp": otpControllers.map((controller) => controller.text).join(),

        }),
      );


      if (response.statusCode == 200) {

        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
              print(responseData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("OTP verified successfully"),
              backgroundColor: Colors.green,
            ),
          );
          String userId=responseData['user_id'].toString();
            await saveUserId(userId);
            print('UserId Saved: $userId');

           print(responseData);
          // Navigate to the next screen4
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NextScreenOfOtp()),
          );

        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You have entered Invalid Otp"),
              backgroundColor: Colors.red,
            ),
          );
        }

      }
    }


    void _resendCode() async {



      if (_isResendEnabled) {

        final token = await getToken();
        print('Retrieved token: $token');


        final mobile=await getPhoneNumber();

        print('Retrieved token:$mobile');

      String apibaseUrl="https://pikaaya.com/development/developmentHottrix/";

        final url = Uri.parse( apibaseUrl+'api/rider/otp/resend'); // Example URL
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'mobile_number':mobile,  // Use the phone number that was used to send OTP
            "token":token,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['status']==true) {





            // Restart the timer after successfully resending the OTP
            _startTimer();

          } else {
            print("Error: ${responseData['message']}");
          }
        } else {
          print("Server error: ${response.statusCode}");
        }
      }
    }











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
                  builder: (context) => MyPhone(),
                ));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Images/otppic.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                "Mobile Number has \nSuccessfully done",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your 4-digit OTP",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "00:${_start.toString().padLeft(2, '0')} sec",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive a code? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: _isResendEnabled ? _resendCode : null,
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          fontSize: 16,
                          color: _isResendEnabled ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                  _verifyOtp,
                  child: Text(
                    "VERIFY & CONTINUE",
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
      ),
    );
  }
}
