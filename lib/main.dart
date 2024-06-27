import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('App Navigation'),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.login), text: 'Sign In'),
              Tab(icon: Icon(Icons.app_registration), text: 'Sign Up'),
              Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
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
        ],
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Sign Up'),
          ),
        ],
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
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
