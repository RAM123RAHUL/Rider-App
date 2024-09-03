import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:pikaaya/last_screen.dart';

void main() => runApp(LastSubmission());

class LastSubmission extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Review'),
          backgroundColor: Colors.indigo,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            return SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please review the information below before final submission.",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    color: Colors.yellow[100],
                    padding: EdgeInsets.all(width * 0.04),
                    child: Text(
                      "Dear Customer, you can refer to and review this information for the best support and help yourself to the next step.",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  SectionWidget(
                    title: "Personal Information",
                    fields: [
                      "Name",
                      "Father's Name",
                      "Date of Birth",
                      "Address",
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  SectionWidget(
                    title: "Vehicle Details",
                    fields: [
                      "Selected Vehicle",
                      "Vehicle Registration Number",
                      "RC Number",
                      "Ownership Status",
                      "T-Shirt Size",
                      "Delivery Address",
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  SectionWidget(
                    title: "PAN Card",
                    fields: [
                      "PAN Card",
                      "Name on PAN Card",
                    ],
                    imagePaths: ['assets/Images/pan_card.png'],
                  ),
                  SizedBox(height: height * 0.02),
                  SectionWidget(
                    title: "UIDAI Card",
                    fields: [
                      "Aadhaar Card Number",
                    ],
                    imagePaths: [
                      'assets/Images/adhar_card.png',
                      'assets/Images/backpicofadhar.png'
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  SectionWidget(
                    title: "Driving Licence",
                    fields: [
                      "Driving Licence Number",
                      "Issue Date",
                      "Validity Date",
                      "Issued by",
                    ],
                    imagePaths: ['assets/Images/driving_licences.png'],
                  ),
                  SizedBox(height: height * 0.03),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LastScreen(),));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final List<String> fields;
  final List<String> imagePaths;

  SectionWidget({required this.title, required this.fields, this.imagePaths = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(title: title, fields: fields, imagePaths: imagePaths),
                      ),
                    );
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            for (var field in fields)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            if (imagePaths.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Wrap(
                  spacing: 8.0,
                  children: imagePaths.map((path) {
                    return Image.asset(path, width: 100, height: 60);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EditScreen extends StatefulWidget {
  final String title;
  final List<String> fields;
  final List<String> imagePaths;

  EditScreen({required this.title, required this.fields, required this.imagePaths});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the first field value for demonstration
    if (widget.fields.isNotEmpty) {
      _controller.text = widget.fields[0];
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.title}'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit ${widget.title} details here'),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ...widget.fields.map((field) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: field,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter $field';
                          }
                          return null;
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle the form submission
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
