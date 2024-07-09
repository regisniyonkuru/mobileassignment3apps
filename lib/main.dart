import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAa03NPFLnYsYMpSY4ED-n1mIZYsj-WXPI",
      authDomain: "calculatorapp-bba02.firebaseapp.com",
      projectId: "calculatorapp-bba02",
      storageBucket: "calculatorapp-bba02.appspot.com",
      messagingSenderId: "447973746446",
      appId: "1:447973746446:web:a36fa5b732d46e03edd95f",
      measurementId: "G-DV5F6Z3F1M",
    ),
  );

runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
        ChangeNotifierProvider<ConnectivityService>(create: (_) => ConnectivityService()),
        ChangeNotifierProvider<BatteryService>(create: (_) => BatteryService()),
        ChangeNotifierProvider<GoogleSignInService>(create: (_) => GoogleSignInService()),
      ],
      child: CalculatorApp(),
    ),
  );
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      theme: themeService.currentTheme,
      home: MainScreen(),
    );
  }
}


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('App Navigation'),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.login), text: 'Sign In'),
              Tab(icon: Icon(Icons.app_registration), text: 'Sign Up'),
              Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
              Tab(icon: Icon(Icons.brightness_6), text: 'Theme'),
            ],
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
          ),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: [
            SignInScreen(),
            SignUpScreen(),
            CalculatorScreen(),
            ThemeScreen(),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Sign In'),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.app_registration),
            title: Text('Sign Up'),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Calculator'),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Theme'),
            onTap: () {
              Navigator.pop(context);
              DefaultTabController.of(context)?.animateTo(3); // updated to correct index
            },
          ),
        ],
      ),
    );
  }
}


class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: themeService.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Theme Screen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Theme'),
            Tab(text: 'Other'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose Theme',
                    style: TextStyle(
                      fontSize: 24,
                      color: themeService.currentTheme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      themeService.toggleTheme();
                    },
                    child: Text('Toggle Theme'),
                  ),
                ],
              ),
            ),
          ),
          Center(child: Text('Content for Other Tab')),
        ],
      ),
    );
  }
}






class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    final user = await GoogleSignInService().signInWithGoogle();
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in with Google: ${user.email}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black, // Set background color
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24,
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => _signIn(context),
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () => _signInWithGoogle(context),
              child: Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _signUp(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black, // Set background color
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24,
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white24,
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => _signUp(context),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
   String _display = '0';
  String _expression = '';
  String _operator = '';
  bool _isResultCalculated = false;

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _clear();
      } else if (text == 'DEL') {
        _delete();
      } else if (text == '%') {
        _calculatePercentage();
      } else if (_isOperator(text)) {
        _handleOperator(text);
      } else if (text == '=') {
        _calculate();
      } else {
        _handleDigit(text);
      }
    });
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _operator = '';
    _isResultCalculated = false;
  }

  void _delete() {
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
  }

  void _calculatePercentage() {
    double currentValue = double.tryParse(_display) ?? 0;
    _display = (currentValue / 100).toString();
  }

  void _handleOperator(String operator) {
    if (_isResultCalculated) {
      _expression = _display + operator;
      _isResultCalculated = false;
    } else {
      _expression += _display + operator;
    }
    _operator = operator;
    _display = '0';
  }

  void _handleDigit(String digit) {
    if (_display == '0' || _isResultCalculated) {
      _display = digit;
      _isResultCalculated = false;
    } else {
      _display += digit;
    }
  }

  void _calculate() {
    if (_expression.isEmpty) return;

    double result = 0;
    if (_operator.isNotEmpty) {
      double firstOperand = double.parse(_expression.substring(0, _expression.length - 1));
      double secondOperand = double.parse(_display);

      switch (_operator) {
        case '+':
          result = firstOperand + secondOperand;
          break;
        case '-':
          result = firstOperand - secondOperand;
          break;
        case 'x':
          result = firstOperand * secondOperand;
          break;
        case '/':
          result = firstOperand / secondOperand;
          break;
        default:
          result = 0.0;
          break;
      }
      _expression += _display + '=';
    } else {
      result = double.parse(_display);
      _expression = _display + '=';
    }

    _display = result.toString();
    _isResultCalculated = true;
    _operator = '';
    _expression = '';
  }

  bool _isOperator(String text) {
    return text == '/' || text == 'x' || text == '-' || text == '+';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          DisplayArea(display: _expression),
          SizedBox(height: 20),
          DisplayArea(display: _display),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                buildButtonRow(['C', '/', 'x', 'DEL']),
                buildButtonRow(['7', '8', '9', '-']),
                buildButtonRow(['4', '5', '6', '+']),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          buildButtonRow(['1', '2', '3']),
                          buildButtonRow(['%', '0', '.']),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CalculatorButton(
                        text: '=',
                        onPressed: _onButtonPressed,
                        flex: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      children: buttons.map((String text) {
        return CalculatorButton(
          text: text,
          onPressed: _onButtonPressed,
          flex: 1,
        );
      }).toList(),
    );
  }
}

class DisplayArea extends StatelessWidget {
final String display;

  DisplayArea({required this.display});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Text(
        display,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final void Function(String) onPressed;
  final int flex;

  CalculatorButton({
    required this.text,
    required this.onPressed,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isOperator(text) || text == 'C' || text == 'DEL' || text == '%' ? Colors.deepOrange : Colors.grey[850],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  bool _isOperator(String text) {
    return text == '/' || text == 'x' || text == '-' || text == '+';
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final Function(int) onPressed;

  NumberButton({required this.number, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // Set button color
          foregroundColor: Colors.white, // Set text color
          padding: EdgeInsets.all(24.0),
        ),
        onPressed: () => onPressed(number),
        child: Text(number.toString()),
      ),
    );
  }
}

class OperationButton extends StatelessWidget {
  final String operation;
  final Function(String) onPressed;

  OperationButton({required this.operation, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // Set button color
          foregroundColor: Colors.white, // Set text color
          padding: EdgeInsets.all(24.0),
        ),
        onPressed: () => onPressed(operation),
        child: Text(operation),
      ),
    );
  }
}

class ClearButton extends StatelessWidget {
  final VoidCallback onPressed;

  ClearButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Set button color
          foregroundColor: Colors.white, // Set text color
          padding: EdgeInsets.all(24.0),
        ),
        onPressed: onPressed,
        child: Text('C'),
      ),
    );
  }
}

class CalculateButton extends StatelessWidget {
  final VoidCallback onPressed;

  CalculateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Set button color
          foregroundColor: Colors.white, // Set text color
          padding: EdgeInsets.all(24.0),
        ),
        onPressed: onPressed,
        child: Text('='),
      ),
    );
  }
}

class ConnectivityService extends ChangeNotifier {
  ConnectivityService() {
    _init();
  }

  void _init() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "No internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Connected to the internet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      notifyListeners();
    });
  }
}

class BatteryService extends ChangeNotifier {
  final Battery _battery = Battery();

  BatteryService() {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      print('Battery status: $state');
      _battery.batteryLevel.then((level) {
        if (state == BatteryState.charging && level >= 90) {
          Fluttertoast.showToast(
            msg: "Battery level above 90% and charging",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }
        notifyListeners();
      });
    });
  }
}

class GoogleSignInService extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
}

class ThemeService extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme.brightness == Brightness.light) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light();
    }
    notifyListeners();
  }
}


