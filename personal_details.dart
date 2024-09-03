import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pikaaya/last_submission.dart'; // To handle JSON encoding/decoding

class PersonalInformationForm extends StatefulWidget {
  @override
  _PersonalInformationFormState createState() => _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<PersonalInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _streetAreaController = TextEditingController();
  final _cityTownController = TextEditingController();
  final _pinCodeController = TextEditingController();

  String? _selectedState = 'Select your state'; // Initialize the selected state

  @override
  void initState() {
    super.initState();
    // Initialize controllers if needed
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _houseNumberController.dispose();
    _streetAreaController.dispose();
    _cityTownController.dispose();
    _pinCodeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  OutlineInputBorder _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Collect the form data
      final String name = _nameController.text;
      final String fatherName = _fatherNameController.text;
      final String dateOfBirth = _dateController.text;
      final String houseNumber = _houseNumberController.text;
      final String streetArea = _streetAreaController.text;
      final String cityTown = _cityTownController.text;
      final String pinCode = _pinCodeController.text;
      final String state = _selectedState ?? '';

      // Prepare the data to be sent to the API
      final Map<String, dynamic> formData = {
        'name': name,
        'father_name': fatherName,
        'date_of_birth': dateOfBirth,
        'house_number': houseNumber,
        'street_area': streetArea,
        'city_town': cityTown,
        'pin_code': pinCode,
        'state': state,
      };

      try {
        final response = await http.post(
          Uri.parse('https://yourapiendpoint.com/submit'), // Replace with your API endpoint
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(formData),
        );

        if (response.statusCode == 200) {
          // If the server returns a successful response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully!')),
          );

          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LastSubmission()),
          );
        } else {
          // If the server returns an error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit form. Please try again.')),
          );
        }
      } catch (e) {
        // If an exception occurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double formFieldHeight = screenSize.height * 0.07; // Adjust form field height
    final double buttonWidth = screenSize.width * 0.4; // Adjust button width

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Submit Personal Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width * 0.04), // Padding based on screen width
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField('Name*', 'Enter your name', TextInputType.text, controller: _nameController),
              SizedBox(height: screenSize.height * 0.02), // Adjust spacing
              _buildTextFormField('Father\'s Name*', 'Enter your father\'s name', TextInputType.text, controller: _fatherNameController),
              SizedBox(height: screenSize.height * 0.02), // Adjust spacing
              _buildDateFormField('Date of Birth*', 'Enter your date of birth'),
              SizedBox(height: screenSize.height * 0.02), // Adjust spacing
              _buildTextFormField('House Number*', 'Enter your house number', TextInputType.number, controller: _houseNumberController),
              SizedBox(height: screenSize.height * 0.02), // Adjust spacing
              _buildTextFormField('Street/Area*', 'Enter your street or area', TextInputType.text, controller: _streetAreaController),
              SizedBox(height: screenSize.height * 0.02), // Adjust spacing
              _buildTextFormField('City/Town*', 'Enter your city or town', TextInputType.text, controller: _cityTownController),
              SizedBox(height: screenSize.height * 0.02), // Adjust spacing
              _buildDropdownFormField(),
              SizedBox(height: screenSize.height * 0.02), // Adjust spacing
              _buildTextFormField('Pin Code*', 'Enter your pin code', TextInputType.number, controller: _pinCodeController),
              SizedBox(height: screenSize.height * 0.04), // Adjust spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'PREVIOUS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: _submitForm, // Call the _submitForm function
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(String label, String hint, TextInputType keyboardType, {IconData? suffixIcon, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: _borderStyle(),
        enabledBorder: _borderStyle(),
        focusedBorder: _borderStyle().copyWith(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        errorBorder: _borderStyle().copyWith(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  TextFormField _buildDateFormField(String label, String hint) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: _dateController.text.isEmpty ? hint : _dateController.text,
        border: _borderStyle(),
        enabledBorder: _borderStyle(),
        focusedBorder: _borderStyle().copyWith(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        errorBorder: _borderStyle().copyWith(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your date of birth';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _buildDropdownFormField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'State',
        hintText: 'Select your state',
        border: _borderStyle(),
        enabledBorder: _borderStyle(),
        focusedBorder: _borderStyle().copyWith(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        errorBorder: _borderStyle().copyWith(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      value: _selectedState,
      items: <String>[
        'Select your state',
        'Andhra Pradesh',
        'Arunachal Pradesh',
        'Assam',
        'Bihar',
        'Chhattisgarh',
        'Goa',
        'Gujarat',
        'Haryana',
        'Himachal Pradesh',
        'Jharkhand',
        'Karnataka',
        'Kerala',
        'Madhya Pradesh',
        'Maharashtra',
        'Manipur',
        'Meghalaya',
        'Mizoram',
        'Nagaland',
        'Odisha',
        'Punjab',
        'Rajasthan',
        'Sikkim',
        'Tamil Nadu',
        'Telangana',
        'Tripura',
        'Uttar Pradesh',
        'Uttarakhand',
        'West Bengal',
        'Andaman and Nicobar Islands',
        'Chandigarh',
        'Dadra and Nagar',
        'Lakshadweep',
        'Delhi',
        'Puducherry',
        'Ladakh',
        'Jammu & Kashmir'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedState = newValue;
        });
      },
      validator: (value) {
        if (value == null || value == 'Select your state') {
          return 'Please select your state';
        }
        return null;
      },
    );
  }
}
