import 'dart:math';
import 'package:autoclub_frontend/utilities/sheets.dart';
import 'package:autoclub_frontend/utilities/user_info.dart';
import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin {
  List<CarModel> _carList = [];
  List<CarModel> shuffledCarList = [];
  bool _isLoading = true;
  PageController _pageController = PageController();
  bool _isPasswordVisible = false; // Add this line
  bool _isSignupPasswordVisible = false; // Add this line for signup
  final _supabaseClient = Supabase.instance.client;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signupUsernameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCarList();
    updateKeepAlive(); // Ensure the state is kept alive
  }

  Future<void> _fetchCarList() async {
    final carList = await getCarList();
    setState(() {
      _carList = carList;
      _isLoading = false;

      // Shuffle the car list to randomize why the images
      final random = Random();
      shuffledCarList = List<CarModel>.from(_carList) // Copy the list
        ..shuffle(random); // Shuffle the copied list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _buildBackgroundGrid(),
                PageView(
                  controller: _pageController,
                  children: [
                    _buildLoginContainer(),
                    _buildSignupContainer(),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildBackgroundGrid() {
    const int gridCount = 70; // Increased number of images in the grid
    const double spacing = 2.0; // Fixed spacing between images

    return Transform.translate(
      offset: Offset(0, 0), // Offset the grid down by 50 pixels
      child: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(spacing),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220, // Maximum extent for each child
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1.0, // Ensure squares
            ),
            itemCount: gridCount,
            itemBuilder: (context, index) {
              final car = shuffledCarList[index % shuffledCarList.length];
              return CachedNetworkImage(
                imageUrl: car.imgLinks, // Use lower resolution URL if available
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            },
            shrinkWrap: true, // Ensure the grid takes only the necessary space
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 2.0, sigmaY: 2.0), // Slight blur effect
            child: Container(
              color: Colors.black
                  .withOpacity(0), // Transparent container to apply blur
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth =
        screenWidth < 1000 ? screenWidth * 0.9 : screenWidth * 0.6;
    final double paddingWidth = screenWidth < 1000 ? 30 : 160;
    return Center(
      child: SimpleShadow(
        sigma: 10,
        child: Container(
          width: containerWidth,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.80), // Semi-transparent white
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: paddingWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome to ',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                    ),
                    TextSpan(
                      text: 'Autoclub',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 39, 131, 176),
                              ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                controller: _usernameController,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: Colors.black),
                controller: _passwordController,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Implement login functionality here
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Login',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth =
        screenWidth < 1000 ? screenWidth * 0.9 : screenWidth * 0.6;
    final double paddingWidth = screenWidth < 1000 ? 30 : 160;

    return Center(
      child: SimpleShadow(
        sigma: 10,
        child: Container(
          width: containerWidth,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90), // Semi-transparent white
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: paddingWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                controller: _signupUsernameController,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email for verification code',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                controller: _signupEmailController,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isSignupPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSignupPasswordVisible = !_isSignupPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isSignupPasswordVisible,
                style: TextStyle(color: Colors.black),
                controller: _signupPasswordController,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Implement signup functionality here
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Sign Up',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Text(
                  'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
