import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'YOUR_API_BASE_URL';

  Future<void> submitDocuments({
    required String panCardNumber,
    required String nameOnPanCard,
    required String aadharCardNumber,
    required String nameOnAadharCard,
    required String drivingLicenceNumber,
    required String issuedBy,
    required String issueDate,
    required String validityDate,
    required File panCardImage,
    required File aadharFrontImage,
    required File aadharBackImage,
    required File drivingLicenseImage
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/submit_documents'),
    );

    request.fields['panCardNumber'] = panCardNumber;
    request.fields['nameOnPanCard'] = nameOnPanCard;
    request.fields['aadharCardNumber'] = aadharCardNumber;
    request.fields['nameOnAadharCard'] = nameOnAadharCard;
    request.fields['drivingLicenceNumber'] = drivingLicenceNumber;
    request.fields['issuedBy'] = issuedBy;
    request.fields['issueDate'] = issueDate;
    request.fields['validityDate'] = validityDate;

    request.files.add(await http.MultipartFile.fromPath('panCardImage', panCardImage.path));
    request.files.add(await http.MultipartFile.fromPath('aadharFrontImage', aadharFrontImage.path));
    request.files.add(await http.MultipartFile.fromPath('aadharBackImage', aadharBackImage.path));
    request.files.add(await http.MultipartFile.fromPath('drivingLicenseImage', drivingLicenseImage.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      print("Documents submitted successfully!");
    } else {
      print("Failed to submit documents.");
    }
  }
}
