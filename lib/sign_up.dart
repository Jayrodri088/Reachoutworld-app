// ignore_for_file: use_build_context_synchronously

import 'package:data_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'verification_code.dart';
import 'api/sign_up_api_service.dart'; // Import your API service

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpApiService apiService = SignUpApiService();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isChecked = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedCountry;
  final List<String> _countries = [    "Afghanistan", "Albania", "Algeria", "Andorra", "Angola",
    "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria",
    "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados",
    "Belarus", "Belgium", "Belize", "Benin", "Bhutan",
    "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei",
    "Bulgaria", "Burkina Faso", "Burundi", "Cabo Verde", "Cambodia",
    "Cameroon", "Canada", "Central African Republic", "Chad", "Chile",
    "China", "Colombia", "Comoros", "Congo, Democratic Republic of the", "Congo, Republic of the",
    "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba", "Cyprus",
    "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic",
    "East Timor (Timor-Leste)", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea",
    "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Fiji",
    "Finland", "France", "Gabon", "Gambia", "Georgia",
    "Germany", "Ghana", "Greece", "Grenada", "Guatemala",
    "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras",
    "Hungary", "Iceland", "India", "Indonesia", "Iran",
    "Iraq", "Ireland", "Israel", "Italy", "Jamaica",
    "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati",
    "Korea, North", "Korea, South", "Kosovo", "Kuwait", "Kyrgyzstan",
    "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia",
    "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar",
    "Malawi", "Malaysia", "Maldives", "Mali", "Malta",
    "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia",
    "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco",
    "Mozambique", "Myanmar (Burma)", "Namibia", "Nauru", "Nepal",
    "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria",
    "North Macedonia", "Norway", "Oman", "Pakistan", "Palau",
    "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru",
    "Philippines", "Poland", "Portugal", "Qatar", "Romania",
    "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines",
    "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal",
    "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia",
    "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Sudan",
    "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden",
    "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania",
    "Thailand", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia",
    "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine",
    "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan",
    "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen",
    "Zambia", "Zimbabwe"];

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _isChecked) {
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await apiService.registerUser(
          _nameController.text,
          _emailController.text,
          _selectedCountry ?? '',
          _passwordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User registered successfully')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          debugPrint('Error: ${response['message']}');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response['message'])));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to register user')));
      }
    } else if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You need to agree with the Terms and Privacy Policy to continue.'),
        ),
      );
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 9) {
      return 'Password must be at least 9 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.1),
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Fill your details below or register with your KingsChat',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  items: _countries.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Country of Residence',
                    prefixIcon: const Icon(Icons.flag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your country';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'I agree with the Terms and Privacy Policy.',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: screenWidth * 0.1,
                        endIndent: screenWidth * 0.02,
                      ),
                    ),
                    Text(
                      'Or Sign up with',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: screenWidth * 0.02,
                        endIndent: screenWidth * 0.1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    // Handle KingsChat login
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0,
                        horizontal: screenWidth * 0.04),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/app_logo.png',
                          width: screenWidth * 0.08,
                          height: screenHeight * 0.08,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Kings Chat',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
