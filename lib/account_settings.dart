import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import dropdown_search
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for jsonDecode

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String? selectedRegion;
  String? selectedZone;
  final TextEditingController emailController = TextEditingController();

  // Define the regions and their respective zones
  final Map<String, List<String>> regionsWithZones = {
    "Region 1": [
      "SA Zone 1", "Cape Town Zone 1", "SA Zone 5", "Cape Town Zone 2",
      "SA Zone 2", "BLW Southern Africa Region", "Middle East Asia", "CE India",
      "SA Zone 3", "Durban", "BLW Asia & North Africa Region"
    ],
    "Region 2": [
      "UK Zone 3 Region 2", "CE Amsterdam DSP", "BLW Europe Region", "Western Europe Zone 4",
      "UK Zone 3 Region 1", "USA Zone 2 Region 1", "Eastern Europe", "Australia Zone",
      "Toronto Zone", "Western Europe Zone 2", "USA Zone 1 Region 2/Pacific Islands Region/New Zealand",
      "USA Region 3", "BLW Canada Sub-Region", "Western Europe Zone 3", "Dallas Zone USA Region 2",
      "UK Zone 4 Region 1", "Western Europe Zone 1", "UK Zone 1 (Region 2)", "UK Zone 2 Region 1",
      "UK Zone 1 Region 1", "USA Zone 1 Region 1", "BLW USA Region 2", "Ottawa Zone",
      "UK Zone 4 Region 2", "Quebec Zone", "BLW USA Region 1"
    ],
    "Region 3": [
      "Kenya Zone", "Lagos Zone 1", "EWCA Zone 4", "CE Chad", "EWCA Zone 2",
      "Ministry Center Warri", "Mid-West Zone", "South West Zone 2", "South West Zone 1",
      "Lagos Zone 4", "Ibadan Zone 1", "Ibadan Zone 2", "Accra Zone", "South West Zone 3",
      "EWCA Zone 5", "EWCA Zone 3", "MC Abeokuta", "EWCA Zone 6"
    ],
    "Region 4": [
      "Abuja Zone 2", "CELVZ", "Lagos Zone 2", "South South Zone 3", "South-South Zone 2",
      "Lagos Zone 3", "EWCA Zone 1", "South-South Zone 1", "DSC Sub Zone Warri", "Ministry Center Abuja",
      "Ministry Center Calabar"
    ],
    "Region 5": [
      "Middle Belt Region Zone 2", "North East Zone 1", "PH Zone 1", "Lagos Zone 6",
      "Lagos Sub Zone B", "Middle Belt Region Zone 1", "PH Zone 3", "Lagos Sub Zone A",
      "South West Zone 5", "Onitsha Zone", "Abuja Zone", "PH Zone 2", "North West Zone 2",
      "Lagos Zone 5", "Northwest Zone 1", "Ministry Center Ibadan", "South West Zone 4",
      "North Central Zone 1", "North Central Zone 2"
    ],
    "Region 6": [
      "Lagos Sub Zone C", "Benin Zone 2", "Aba Zone", "Benin Zone 1", "Loveworld Church Zone",
      "South East Zone 1", "BLW West Africa Region", "BLW East & Central Africa Region", "South East Zone 3",
      "Edo North & Central", "BLW Nigeria Region"
    ],
  };

  Future<void> _saveAccountSettings() async {
    // API endpoint URL
    const String apiUrl = 'http://apps.qubators.biz/reachoutworlddc/update_region_zone.php';

    // Get user input
    String email = emailController.text;
    String region = selectedRegion ?? '';
    String zone = selectedZone ?? '';

    // Check if email is provided
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      // Send POST request to the backend
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'email': email,
          'region': region,
          'zone': zone,
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account settings updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${jsonResponse['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update account settings')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/arrow.png', // Your custom back arrow image
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            _buildEmailInputField(), // Allow email input
            const SizedBox(height: 16),
            _buildRegionDropdown(context), // Region Dropdown
            const SizedBox(height: 16),
            _buildZoneDropdown(context),   // Zone Dropdown with Search
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAccountSettings, // Call _saveAccountSettings when Save is clicked
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 82, 109, 208),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Email Input Field
  Widget _buildEmailInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Enter registered email',
            prefixIcon: const Icon(Icons.mail_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  // Widget for Region Dropdown
  Widget _buildRegionDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Region',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedRegion,
          items: regionsWithZones.keys.map((String region) {
            return DropdownMenuItem<String>(
              value: region,
              child: Text(region),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedRegion = newValue;
              selectedZone = null; // Reset the zone when region changes
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.map),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // Widget for Zone Dropdown with Search
  Widget _buildZoneDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Zone',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          popupProps: PopupProps.dialog(
            showSearchBox: true,
            searchFieldProps: const TextFieldProps(
              decoration: InputDecoration(
                labelText: 'Search Zone',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          items: selectedRegion != null
              ? regionsWithZones[selectedRegion!]!
              : [],
          onChanged: (String? newValue) {
            setState(() {
              selectedZone = newValue;
            });
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: "Enter your zone",
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          selectedItem: selectedZone,
          clearButtonProps: const ClearButtonProps(isVisible: true),
        ),
      ],
    );
  }
}
