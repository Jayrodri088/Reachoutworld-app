import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'sidebar.dart';
import 'data_capture_form.dart';
import 'leaderboard_screen.dart';
import 'statistics_screen.dart';
import 'recent_activities_screen.dart';
import 'wallet_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String userCountry;

  const DashboardScreen(
      {super.key, required this.userName, required this.userCountry});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardContent(),
    const WalletScreen(),
    RecentActivitiesScreen(),
    const Center(child: Text('Settings Screen Placeholder')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(
        userName: widget.userName,
        userCountry: widget.userCountry,
        profileImage: 'assets/profile_1.webp',
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _buildBottomNavigationBarItem('assets/icon/home.png', 'Home', 0),
          _buildBottomNavigationBarItem('assets/icon/wallet_1.png', 'Wallet', 1),
          _buildBottomNavigationBarItem('assets/icon/history_1.png', 'History', 2),
          _buildBottomNavigationBarItem('assets/icon/settings_3.png', 'Settings', 3),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      String iconPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: _selectedIndex == index
          ? Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(172, 245, 151, 10),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            )
          : Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
      label: label,
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = (ModalRoute.of(context)!.settings.arguments
        as Map)['userName']; // Access user's name passed from LoginScreen
    final String userCountry = (ModalRoute.of(context)!.settings.arguments
        as Map)['userCountry']; // Access user's country passed from LoginScreen

    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: Row(
            children: [
              Builder(builder: (context) {
                return IconButton(
                  icon: Image.asset(
                    'assets/icon/dashboard.png',
                    width: screenWidth * 0.1,
                    height: screenHeight * 0.05,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              const Spacer(),
              IconButton(
                icon: Image.asset(
                  'assets/icon/notification.png',
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.05,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Row(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.1,
                backgroundImage: const AssetImage('assets/profile_1.webp'),
              ),
              SizedBox(width: screenWidth * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $userName',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userCountry,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.035),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
        Container(
          width: screenWidth,
          height: screenHeight * 0.02, // Adjust height dynamically
          decoration: const BoxDecoration(
            color: Color.fromARGB(204, 245, 151, 10),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              bottom: screenHeight * 0.04,
            ),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing:
                  screenHeight * 0.02, // Adjust spacing dynamically
              crossAxisSpacing:
                  screenWidth * 0.02, // Adjust spacing dynamically
              children: [
                _buildGridItem(context, 'assets/icon/capture_form.png',
                    'Data Capture', const DataCaptureForm()),
                _buildGridItem(context, 'assets/icon/leaderboard.png',
                    'Leader board', const LeaderboardScreen()),
                _buildGridItem(context, 'assets/icon/statistics.png',
                    'Statistics', const StatisticsScreen()),
                _buildGridItem(context, 'assets/icon/capture.png',
                    'Media Capture', const CameraScreen()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, String imagePath, String title,
      [Widget? destination]) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      shadowColor: Colors.black54,
      child: InkWell(
        onTap: destination != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              }
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: screenWidth * 0.15, // Adjust width dynamically
              height: screenHeight * 0.1, // Adjust height dynamically
            ),
            SizedBox(height: screenHeight * 0.01), // Adjust height dynamically
            Text(
              title,
              style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold), // Adjust font size dynamically
            ),
          ],
        ),
      ),
    );
  }
}
