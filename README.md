# ReachOutWorld App

## Overview
**ReachOutWorld** is a mobile app designed to connect users with the gospel and help them reach out to others across the globe. It allows users to gather and store contact information of individuals from different regions and use it for spreading the gospel via social media, email, and other communication platforms.

Additionally, the app includes a media section where users can capture moments of their gospel outreach (photos and videos) and share them on social media platforms.

**Team Members**:
- John Asogwa[Flutter Dev]
- Abimbola Ibukun[UI/Ux]
- 
-
-
-

When a user is registered, the data is stored in the database and can be accessed by the backend server, but if the user is not able to register, the approriate error message is displayed to the user which you can configure in the sign_up.dart file to display the actual error message from the backend server or that you wish the user to see.

After a successful registration, the user is redirected to the login page where the user can login to the app, the login details will be sent to the backend server for verification and if the login details are correct, the user is redirected to the dashboard where the user can access the app's features.

In the dashboard, there is a circle avatar that when clicked, allows the user to update their profile picture which will be stored in the database and can be accessed by the backend server, although the uploads folder is not ready yet but will be ready soon.
Then there is a sidebar that allows the user to navigate to the feedback page and logout button.
In the main part of the dashboard, there is a button that allows the user to access the data capture form where the user can enter the contact details of the individuals they meet during their outreach, the data is then stored in the database and can be accessed by the backend server.
There is also a media capture button where the user can capture photos or videos of their outreach moments, the media is then uploaded to the server and can be accessed by the backend server.
There is also a leaderboard button where the user can see how they rank on the leaderboard based on their outreach activities.

There are also bottom navigation bar that allows the user to navigate between the dashboard, recent activities, wallet and settings.

In the recent activities page, the user can see the recent activities of both the data capture and media capture.



## Features
### 1. **Data Capture**
- Users can submit contact information, including name, email, phone, and country of residence.
- The information is securely stored for later use in gospel outreach campaigns via various communication methods.
- No duplicate entries are allowed, ensuring data integrity.

### 2. **Media Capture**
- Users can capture photos or videos to document moments of gospel outreach.
- The app allows users to upload media files and share them on social media platforms.
  
### 3. **User Profile Management**
- Users can upload and update their profile picture.
- The app stores user details such as name and country, allowing users to manage their personal information.
  
### 4. **Recent Activities & Leaderboards**
- Track recent activities related to data capture and media uploads.
- See how users rank on the leaderboard based on their outreach activity.

### 5. **Feedback System**
- Users can provide feedback on the app and their experiences, helping developers improve the app’s functionality.

## Screens & Functionality
### 1. **Dashboard**
- A centralized view that provides quick access to Data Capture, Media Capture, Leaderboards, and Statistics.
- Users can access their profile details and update their profile image.

### 2. **Data Capture Form**
- A simple form where users can enter contact information of individuals they meet during outreach.
- Data is stored securely in the database, avoiding duplicates.

### 3. **Media Capture**
- Allows users to capture photos or record videos.
- Media files can be uploaded to a server, and users can share these moments on social media platforms like Facebook, Instagram, and Twitter.

### 4. **Sidebar Navigation**
- Provides access to Feedback, Profile Settings, and Log Out options.
  
### 5. **Leaderboards**
- Encourages friendly competition by ranking users based on their outreach activities.

### 6. **Feedback Form**
- A dedicated section where users can share their feedback on the app.

## Technology Stack
- **Frontend**: Flutter (for cross-platform mobile app development)
  - Utilizes Flutter widgets for building a responsive UI.
  - Local data storage is managed using **Sqflite**.
  - global data storage is managed using **php** and **mysql**
  - 
  
- **Backend**: 
  - **PHP** for handling backend services, such as user registration, media uploads, and contact information storage.
  - **MySQL** for managing user data and media content.
  - REST API handles communication between the frontend and backend.

## Installation

### Prerequisites
- **Flutter SDK** installed on your machine.
- **PHP** and **MySQL** for backend server setup.

### Steps

### 1. **Clone the repository**:
   
  - git clone https://github.com/Jayrodri088/reachoutworld.git.
  - cd reachoutworld.

###  2. **Install dependencies**: 
   
  -  Ensure you have Flutter and Dart installed, then run:
  -  flutter pub get

### 3. **Set up the backend**:
    
    Set up a MySQL database using the schema required for user profiles, media uploads, and captured data.
    Ensure that the backend PHP files for handling user data, media uploads, and API services are properly configured.
    Update the URLs in the Flutter app to point to your backend API.

### 4. **Run the app**:
    
    flutter run
