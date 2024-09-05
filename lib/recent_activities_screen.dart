import 'package:flutter/material.dart';
import 'Sqflite/media_database.dart'; // Import your database helper
import 'sign_in.dart'; // Adjust the import path according to your project structure

class RecentActivitiesScreen extends StatefulWidget {
  const RecentActivitiesScreen({super.key});

  @override
  _RecentActivitiesScreenState createState() => _RecentActivitiesScreenState();
}

class _RecentActivitiesScreenState extends State<RecentActivitiesScreen> {
  bool isDataCaptureSelected = true;
  List<Map<String, dynamic>> mediaList = []; // List to hold media data
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Initialize DatabaseHelper

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.014),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.075),
                  // Search bar with filter button
                  //JAC
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.012,
                                horizontal: screenWidth * 0.012),
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.006),
                      IconButton(
                        onPressed: () {
                          // Handle filter button press
                        },
                        icon: Image.asset(
                          'assets/icon/Filter.png',
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  // Toggle buttons for Data Capture and Media Capture
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isDataCaptureSelected = true;
                              });
                            },
                            child: Text(
                              'Data Capture',
                              style: TextStyle(
                                color: isDataCaptureSelected
                                    ? Color.fromARGB(255, 32, 55, 187)
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.04,
                          width: 1,
                          color: Color.fromARGB(255, 32, 55, 187),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isDataCaptureSelected = false;
                                _loadMediaData(); // Load media data when Media Capture is selected
                              });
                            },
                            child: Text(
                              'Media Capture',
                              style: TextStyle(
                                color: isDataCaptureSelected
                                    ? Colors.grey
                                    : Color.fromARGB(255, 32, 55, 187),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Display the recent activities in tabular form if Data Capture is selected
                  isDataCaptureSelected
                      ? Expanded(
                          child: recentActivities.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Name')),
                                      DataColumn(label: Text('Email')),
                                      DataColumn(label: Text('Phone')),
                                      DataColumn(label: Text('Country')),
                                      DataColumn(label: Text('Date')),
                                    ],
                                    rows: recentActivities.map((activity) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(activity['name'])),
                                          DataCell(Text(activity['email'])),
                                          DataCell(Text(activity['phone'])),
                                          DataCell(Text(activity['country'])),
                                          DataCell(Text(activity['created_at'])),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'No Recent Activities Found',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                ),
                        )
                      : Expanded(
                          child: mediaList.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('File Path')),
                                      DataColumn(label: Text('Type')),
                                      DataColumn(label: Text('Timestamp')), // New timestamp column
                                    ],
                                    rows: mediaList.map((media) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(media['file_path'])),
                                          DataCell(Text(media['media_type'])),
                                          DataCell(Text(media['timestamp'])), // Display timestamp
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'No Media Captured Yet',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                ),
                        ),
                ],
              ),
            ),
            // Positioned back arrow icon, History text, and Settings icon
            Positioned(
              top: screenHeight * 0.02,
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //   icon: Image.asset(
                  //     'assets/arrow.png',
                  //     width: screenWidth * 0.09,
                  //     height: screenWidth * 0.09,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  SizedBox(width: screenWidth * 0.09),
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.09),
                  // IconButton(
                  //   icon: Image.asset(
                  //     'assets/icon/settings_1.png',
                  //     width: screenWidth * 0.089,
                  //     height: screenWidth * 0.089,
                  //   ),
                  //   onPressed: () {
                  //     // Handle settings icon press
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMediaData() async {
    try {
      final data = await _dbHelper.getMedia();
      setState(() {
        mediaList = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load media: $e')),
      );
    }
  }
}
