import 'package:flutter/material.dart';

class RecentActivitiesScreen extends StatefulWidget {
  @override
  _RecentActivitiesScreenState createState() => _RecentActivitiesScreenState();
}

class _RecentActivitiesScreenState extends State<RecentActivitiesScreen> {
  bool isDataCaptureSelected = true;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height:
                          screenHeight * 0.075), // Adjust height dynamically
                  // Search bar with filter button
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
                          'assets/icon/Filter.png', // Replace with your filter icon path
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
                      color: Colors.orange[100],
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
                                    ? Colors.orange
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
                          color: Colors.orange,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isDataCaptureSelected = false;
                              });
                            },
                            child: Text(
                              'Media Capture',
                              style: TextStyle(
                                color: isDataCaptureSelected
                                    ? Colors.grey
                                    : Colors.orange,
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
                  // Placeholder for additional content
                  Center(
                    child: Text(
                      'No History Yet',
                      style: TextStyle(fontSize: screenWidth * 0.05),
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
                  IconButton(
                    icon: Image.asset(
                      'assets/arrow.png', // Replace with your image path
                      width: screenWidth * 0.09,
                      height: screenWidth * 0.09,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icon/settings_1.png', // Replace with your settings icon path
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                    ),
                    onPressed: () {
                      // Handle settings icon press
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
