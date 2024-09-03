import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pikaaya/phone_otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TopNotification extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const TopNotification({
    Key? key,
    required this.message,
    this.backgroundColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Material(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool agreeToPrivacyPolicy = false;
  bool acceptTermsAndConditions = false;

  @override
  void initState() {
    super.initState();
    countryController.text = "+91";
  }

  void _openPrivacyPolicy() {
    print("Privacy policy clicked");
  }

  void _openTermsAndConditions() {
    print("Terms and conditions clicked");
  }

  Future<void> _sendOtp() async {
    final url = Uri.parse('https://pikaaya.com/development/developmentHottrix/api/delivery_login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "mobile_number": phoneNumberController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        final token = responseData['token'];
        await saveToken(token);
        await savePhoneNumber(phoneNumberController.text);
        final userid=responseData['user_id'];


           print(responseData);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen()),
        );
      } else {
        showTopNotification("Mobile number is not registered");
      }
    } else {
      showTopNotification("Mobile Number is not Registered");
    }
  }

  void showTopNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => TopNotification(
        message: message,
        backgroundColor: Colors.red,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone_number', phoneNumber);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }






  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/Images/boylogo.png',
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Continue with your Mobile \n Number",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(width: screenWidth * 0.02),
                    SizedBox(
                      width: screenWidth * 0.15,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: screenHeight * 0.05, color: Colors.grey),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              CheckboxListTile(
                value: agreeToPrivacyPolicy,
                onChanged: (bool? value) {
                  setState(() {
                    agreeToPrivacyPolicy = value!;
                  });
                },
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Privacy',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _openPrivacyPolicy,
                      ),

                      TextSpan(
                        text: ' & ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Policy',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _openPrivacyPolicy,
                      ),
                    ],
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                value: acceptTermsAndConditions,
                onChanged: (bool? value) {
                  setState(() {
                    acceptTermsAndConditions = value!;
                  });
                },
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'I accept the ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _openTermsAndConditions,
                      ),
                    ],
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onPressed: () {
                    if (agreeToPrivacyPolicy && acceptTermsAndConditions) {
                      // _sendOtp();

                    } else {
                      showTopNotification("Please accept the privacy policy and terms and conditions");
                    }
                  },
                  child: Text(
                    "SEND OTP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
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
