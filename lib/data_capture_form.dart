// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'api/api_service.dart';

class DataCaptureForm extends StatefulWidget {
  const DataCaptureForm({super.key});

  @override
  _DataCaptureFormState createState() => _DataCaptureFormState();
}

class _DataCaptureFormState extends State<DataCaptureForm> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final List<String> _countries = [
    'Nigeria',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia'
    // Add more countries as needed
  ];

  Future<void> _captureData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await apiService.registerUser(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
          _countryController.text,
        );

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data captured successfully')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response['message'])));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to capture data')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16), // Top padding
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/arrow.png',
                      height: 30,
                      width: 30,
                    ), // Replace with your back button image path
                    iconSize: 24,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Data Form',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill your details below',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'Country of Residence',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.flag),
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (String value) {
                      _countryController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return _countries
                          .map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem(child: Text(value), value: value);
                      }).toList();
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country of residence';
                  }
                  return null;
                },
                // onChanged: (value) {
                //   setState(() {
                //     _selectedCountry = value.isEmpty ? null : value;
                //   });
                // },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _captureData,
                style: ElevatedButton.styleFrom(
                  // primary: Colors.orange,
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
