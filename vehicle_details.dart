import 'package:flutter/material.dart';
import 'package:pikaaya/submit_document.dart';
import 'package:pikaaya/personal_details.dart';


class VehicleDetailsScreen extends StatefulWidget {

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  String selectedVehicle = 'Electric Vehicle';
  String ownershipStatus = 'Own';
  String selectedSize = 'L';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitDocument(),
            ));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVehicleSelection(),
              SizedBox(height: 20),
              _buildTextField('Vehicle Registration Number', 'Enter your name'),
              SizedBox(height: 20),
              _buildTextField('RC Number', 'Enter your father name'),
              SizedBox(height: 20),
              _buildOwnershipStatus(),
              SizedBox(height: 20),
              _buildTShirtSize(),
              SizedBox(height: 20),
              _buildTextField('Delivery Address', 'Enter Address'),
              SizedBox(height: 40),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSelection() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Vehicle'),
          Column(
            children: [
              RadioListTile<String>(
                title: Text('Electric Vehicle'),
                value: 'Electric Vehicle',
                groupValue: selectedVehicle,
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('2-wheeler'),
                value: '2-wheeler',
                groupValue: selectedVehicle,
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('3-wheeler'),
                value: '3-wheeler',
                groupValue: selectedVehicle,
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('4-wheeler'),
                value: '4-wheeler',
                groupValue: selectedVehicle,
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Bicycle'),
                value: 'Bicycle',
                groupValue: selectedVehicle,
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildOwnershipStatus() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ownership Status'),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Own'),
                  value: 'Own',
                  groupValue: ownershipStatus,
                  onChanged: (value) {
                    setState(() {
                      ownershipStatus = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Rented'),
                  value: 'Rented',
                  groupValue: ownershipStatus,
                  onChanged: (value) {
                    setState(() {
                      ownershipStatus = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTShirtSize() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['S', 'M', 'L', 'XL', 'XXL'].map((size) {
        return ChoiceChip(
          label: Text(size),
          selected: selectedSize == size,
          onSelected: (selected) {
            setState(() {
              selectedSize = size;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitDocument(),
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Background color
          ),
          child: Text('PREVIOUS',
            style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,)
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalInformationForm(),
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Background color
          ),
          child: Text('NEXT',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    )
          ),
        ),
      ],
    );
  }
}
