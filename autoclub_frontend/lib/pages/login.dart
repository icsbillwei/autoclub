import 'dart:math';
import 'package:autoclub_frontend/pages/home.dart';
import 'package:autoclub_frontend/utilities/sheets.dart';
import 'package:autoclub_frontend/utilities/user_info.dart';
import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final _signupUsernameController = TextEditingController();

  int currPage = 0;

  String _userId = '';

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      final user = session?.user;

      if (user != null) {
        setState(() {
          _userId = user.id;
        });

        // Check if the user already has a username set
        await _checkUserProfile();
      } else {
        // Handle the case where the user is not authenticated
        // print("null user");
        // _showDialog('Error', 'User is not authenticated.');
      }
    });

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

  Future<void> _checkUserProfile() async {
    // print("check user profile");
    try {
      final response = await supabase
          .from('profiles')
          .select(
              'username, time, currentDay, money, currentCar, userCarList, currUserCarId, daysLeft')
          .eq('id', _userId)
          .single();

      if (response.isEmpty) {
        print("1");
        setState(() {
          currPage = 1;
        });
      } else if (response['username'] == null) {
        print("2");
        setState(() {
          currPage = 1;
        });
      } else {
        print("3");
        // User exists, create UserData from the response
        UserData existingUserData;
        try {
          existingUserData = UserData.fromMap(response);
        } catch (e) {
          // print("User data not yet created");
          existingUserData = UserData(
            username: response['username'],
            time: const TimeOfDay(hour: 9, minute: 00),
            currentDay: 1,
            money: 10000,
            currentCar: null,
            userCarList: [],
            currUserCarId: 0,
            daysLeft: 5,
          );
          print("ERR LOADING DB DATA");
          print(e);
        }

        // Navigate to the main app page or dashboard with the existing UserData object
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              userData: existingUserData,
              supabase: supabase,
              userId: _userId,
            ),
          ),
        );
      }
    } catch (e) {
      _showDialog('Error', 'Failed to fetch user profile1: $e');
    }
  }

  Future<void> _usernameInitialize() async {
    // print("User Initialize");
    final username = _signupUsernameController.text.trim();

    if (username.isEmpty) {
      _showDialog('Error', 'Username cannot be empty!');
      return;
    }

    try {
      try {
        await supabase.from('profiles').upsert({
          'id': _userId,
          'username': username,
        });
      } on PostgrestException catch (e) {
        e.code;
      }

      UserData newUserData = UserData(
        username: username,
        time: const TimeOfDay(hour: 9, minute: 00),
        currentDay: 1,
        money: 10000,
        currentCar: null,
        userCarList: [],
        currUserCarId: 0,
        daysLeft: 5,
      );

      // Navigate to the main app page or dashboard
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            userData: newUserData,
            supabase: supabase,
            userId: _userId,
          ),
        ),
      );
    } catch (e) {
      _showDialog('Error', 'Failed to set username1: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _buildBackgroundGrid(),
                currPage == 0
                    ? _buildGoogleSignInContainer()
                    : _usernameCreationContainer(),
              ],
            ),
    );
  }

  String _getSmallImageUrl(String url) {
    final extensionIndex = url.lastIndexOf('.');
    if (extensionIndex == -1)
      return url; // No extension found, return original URL

    final baseUrl = url.substring(0, extensionIndex);
    final extension = url.substring(extensionIndex);
    return '${baseUrl}s$extension'; // Insert 's' before the extension
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
                imageUrl: _getSmallImageUrl(
                    car.imgLinks), // Use lower resolution URL if available
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => Container(
                  color: const Color.fromARGB(
                      255, 209, 231, 248), // Light grey placeholder
                ),
              );
            },
            shrinkWrap: true, // Ensure the grid takes only the necessary space
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 3.0, sigmaY: 3.0), // Slight blur effect
            child: Container(
              color: Colors.black
                  .withOpacity(0), // Transparent container to apply blur
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInContainer() {
    // print("Google Sign In Container");
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
              ElevatedButton(
                onPressed: () async {
                  // Google Sign-In functionality
                  await supabase.auth.signInWithOAuth(OAuthProvider.google);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.login, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Sign in with Google',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ]),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameCreationContainer() {
    // print("Username Creation Container");
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth =
        screenWidth < 1000 ? screenWidth * 0.9 : screenWidth * 0.6;
    final double paddingWidth = screenWidth < 1000 ? 30 : 160;

    return Center(
      child: SimpleShadow(
        sigma: 10,
        child: Container(
          width: containerWidth,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90), // Semi-transparent white
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: paddingWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Set Your Username',
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
              ElevatedButton(
                onPressed: _usernameInitialize,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Save and Enter Game',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
