import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:pikaaya/APISERVICES/Api_services.dart';

import 'vehicle_details.dart';

class SubmitDocument extends StatefulWidget {
  const SubmitDocument({Key? key}) : super(key: key);

  @override
  State<SubmitDocument> createState() => _SubmitDocumentState();
}

class _SubmitDocumentState extends State<SubmitDocument> {
  File? _panCardImage;
  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _drivingLicenseImage;

  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _panCardNumberController = TextEditingController();
  final TextEditingController _nameOnPanCardController = TextEditingController();
  final TextEditingController _aadharCardNumberController = TextEditingController();
  final TextEditingController _nameOnAadharCardController = TextEditingController();
  final TextEditingController _drivingLicenceNumberController = TextEditingController();
  final TextEditingController _issuedByController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _validityDateController = TextEditingController();

  final ApiService apiService = ApiService();

  Future<void> _pickImage(ImageSource source, String field) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        switch (field) {
          case 'pan':
            _panCardImage = File(pickedFile.path);
            break;
          case 'aadharFront':
            _aadharFrontImage = File(pickedFile.path);
            break;
          case 'aadharBack':
            _aadharBackImage = File(pickedFile.path);
            break;
          case 'driving':
            _drivingLicenseImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  Future<void> _pickDocument(String field) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      setState(() {
        File file = File(result.files.single.path!);
        switch (field) {
          case 'pan':
            _panCardImage = file;
            break;
          case 'aadharFront':
            _aadharFrontImage = file;
            break;
          case 'aadharBack':
            _aadharBackImage = file;
            break;
          case 'driving':
            _drivingLicenseImage = file;
            break;
        }
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context, String field) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.insert_drive_file),
                title: Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  _pickDocument(field);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, field);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, field);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _issueDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _selectDate1(BuildContext context, String field) async {
    final DateTime now = DateTime.now();
    DateTime? selectedDate1 = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate1 != null) {
      setState(() {
        _validityDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate1);
      });
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Document'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('PAN Card Number', 'Enter your PAN number', _panCardNumberController),
                _buildTextField('Name on PAN Card', 'Enter name on PAN card', _nameOnPanCardController),
                _buildImageUploadSection('PAN Card Photo', _panCardImage, 'pan'),
                _buildTextField('Aadhar Card Number', 'Enter your Aadhar number', _aadharCardNumberController),
                _buildTextField('Name on Aadhar Card', 'Enter name on Aadhar card', _nameOnAadharCardController),
                _buildImageUploadSection('Aadhar Card Photo (Frontside)', _aadharFrontImage, 'aadharFront'),
                _buildImageUploadSection('Aadhar Card Photo (Backside)', _aadharBackImage, 'aadharBack'),
                _buildTextField('Driving Licence Number', 'Enter your driving licence number', _drivingLicenceNumberController),
                _buildDatePickerField('Issue Date', _issueDateController),
                _buildDatePickerField1('Validity Date', _validityDateController),
                _buildTextField('Issued by', 'Enter issuing authority', _issuedByController),
                _buildImageUploadSection('Driving Licence Image', _drivingLicenseImage, 'driving'),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () async {
                      // if (_formKey.currentState!.validate() &&
                      //     _panCardImage != null &&
                      //     _aadharFrontImage != null &&
                      //     _aadharBackImage != null &&
                      //     _drivingLicenseImage != null) {
                      //   await apiService.submitDocuments(
                      //     panCardNumber: _panCardNumberController.text,
                      //     nameOnPanCard: _nameOnPanCardController.text,
                      //     aadharCardNumber: _aadharCardNumberController.text,
                      //     nameOnAadharCard: _nameOnAadharCardController.text,
                      //     drivingLicenceNumber: _drivingLicenceNumberController.text,
                      //     issuedBy: _issuedByController.text,
                      //     issueDate: _issueDateController.text,
                      //     validityDate: _validityDateController.text,
                      //     panCardImage: _panCardImage!,
                      //     aadharFrontImage: _aadharFrontImage!,
                      //     aadharBackImage: _aadharBackImage!,
                      //     drivingLicenseImage: _drivingLicenseImage!,
                      //   );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VehicleDetailsScreen()),
                        );
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Please complete all required fields and upload all documents.')),
                      //   );
                     // }
                    },
                    child: Text(
                      "NEXT",
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
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: _validateNotEmpty,
      ),
    );
  }

  Widget _buildImageUploadSection(String label, File? imageFile, String field) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () {
              _showImageSourceActionSheet(context, field);
            },
            child: Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: imageFile != null
                  ? Image.file(imageFile, fit: BoxFit.cover)
                  : Center(child: Icon(Icons.upload_file, size: 50, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _selectDate(context, label),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Select date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: _validateDate,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField1(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _selectDate1(context, label),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Select date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: _validateDate,
          ),
        ),
      ),
    );
  }
}
