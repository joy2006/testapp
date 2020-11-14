import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Load(),
    );
  }
}
class Load extends StatefulWidget {
  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  bool loged;
  Map userdata;
  @override
  void initState() {
    getState();
    super.initState();
  }
  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //getting saved user credintial for auto login
    String email = prefs.getString('email');
    String pass = prefs.getString('pass');
    final http.Response response = await http.post(
      'https://api.mocki.io/v1/b4209c6d',
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      prefs.setBool('loged',true);
      setState(() {
        userdata = jsonDecode(response.body);
      });
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create album.');
    }
  }
  getState()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool Loged = prefs.get('loged');
    if(Loged==true){
      autoLogin();
    }
    setState(() {
      loged = Loged;
    });
  }
  @override
  Widget build(BuildContext context) {
    return (loged==true)?Scaffold(
      body: Biometric(data: userdata,),
    ):MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  double borderRadius = 25;
  String pass,email;

    login(context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      'https://api.mocki.io/v1/b4209c6d',
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Biometric(data:jsonDecode(response.body))));
      prefs.setBool('loged',true);
      prefs.setString('email','test@email.com');
      prefs.setString('pass', '12345678');
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create album.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding:EdgeInsets.symmetric(vertical: 5.0),
              child: TextFormField(
                enabled: false,
                decoration: new InputDecoration(
                  labelText: 'test@email.com',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                      borderRadius:
                      new BorderRadius.circular(borderRadius),
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      )),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(borderRadius),
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      )),
                  focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(borderRadius),
                      borderSide: new BorderSide(
                        color:Colors.blue,
                      )),
                ),
                validator: (val) {
                  if(val==null){
                    return 'Cant be null';
                  }else{
                    return null;
                  }
                },
                onChanged: (value) {
                  email = value; //get the value entered by user.
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  height: 1.0,
                  color: Colors.black,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Container(
              padding:EdgeInsets.symmetric(vertical: 5.0),
              child: TextFormField(
                obscureText: true,
                enabled: false,
                decoration: new InputDecoration(
                  labelText: '********',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: new OutlineInputBorder(
                      borderRadius:
                      new BorderRadius.circular(borderRadius),
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      )),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(borderRadius),
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      )),
                  focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(borderRadius),
                      borderSide: new BorderSide(
                        color:Colors.blue,
                      )),
                ),
                validator: (val) {
                  if(val==null){
                    return 'Cant be null';
                  }else{
                    return null;
                  }
                },
                onChanged: (value) {
                  pass = value; //get the value entered by user.
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  height: 1.0,
                  color: Colors.black,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            SizedBox(
              height:50,
            ),
            GestureDetector(
              onTap: (){
                login(context);
              },
              child: Container(
                width: 100,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius))
                ),
                child: Text("Login",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
              ),
            ),
            Text("Forgot Password ?",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Dont Have an Account ?',
                  style: TextStyle(color: Colors.black54),
                  children:[
                    TextSpan(
                        text: '  Sign Up',
                        style:TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                        recognizer:TapGestureRecognizer()
                          ..onTap=(){
                          }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Biometric extends StatefulWidget {
  final data;
  const Biometric({Key key, this.data}) : super(key: key);
  @override
  _BiometricState createState() => _BiometricState();
}
class _BiometricState extends State<Biometric> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics = [];
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  bool isAuthenticated = false;
  _onPasscodeEntered(String enteredPasscode) {
    print(widget.data['data']['password']);
    bool isValid = widget.data['data']['password'] == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home(data:widget.data)));
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
  }
  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
  _buildPasscodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: FlatButton(
        child: Text(
          "Reset passcode",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        splashColor: Colors.white.withOpacity(0.4),
        highlightColor: Colors.white.withOpacity(0.2),
        onPressed: _resetAppPassword,
      ),
    ),
  );
  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }
  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            FlatButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    final String message = authenticated ? 'Authorized' : 'Not Authorized';
   authenticated?Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Home(data:widget.data))):Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Error()));
    setState(() {
      _authorized = message;
    });
  }
  void _cancelAuthentication() {
    setState(() {
      _isAuthenticating = false;
    });
    auth.stopAuthentication();
  }
  @override
  void initState() {
    _checkBiometrics();
    _getAvailableBiometrics();
    super.initState();
  }
  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.teal
              ]
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.center,
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap:_authenticate,
                      child: Icon(Icons.fingerprint,color: Colors.white,size:150,)),
                 /*Text('Can check biometrics: $_canCheckBiometrics\n'),
                  RaisedButton(
                    child: const Text('Check biometrics'),
                    onPressed: _checkBiometrics,
                  ),
                  Text('Available biometrics: $_availableBiometrics\n'),
                  RaisedButton(
                    child: const Text('Get available biometrics'),
                    onPressed: _getAvailableBiometrics,
                  ),*/
                  FlatButton(
                    child: Text(_isAuthenticating ? 'Cancel' : 'Continue',style: TextStyle(color:Colors.white),),
                    onPressed:
                    _isAuthenticating ? _cancelAuthentication : (){},
                  ),
                ])
        ),
        bottomNavigationBar: Container(
          child: FlatButton(
              child: Text("Use Pin",style: TextStyle(color:Colors.white),),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>PasscodeScreen(
                  title: Text(
                    'Enter PassCode',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  passwordEnteredCallback: _onPasscodeEntered,
                  circleUIConfig: CircleUIConfig(borderColor: Colors.transparent, fillColor: Colors.white, circleSize: 20),
                  keyboardUIConfig: KeyboardUIConfig(digitBorderWidth: 2, primaryColor: Colors.blue),
                  cancelButton: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  digits: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
                  deleteButton: Text(
                    'Delete',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    semanticsLabel: 'Delete',
                  ),
                  shouldTriggerVerification: _verificationNotifier.stream,
                  backgroundColor: Colors.blue,
                  cancelCallback: _onPasscodeCancelled,
                  passwordDigits:8,
                  bottomWidget: _buildPasscodeRestoreButton(),
                ),));
              }
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final data;
  const Home({Key key, this.data}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  Future<bool> _willPopCallback() async {
    return false;
  }
  final LocalAuthentication auth = LocalAuthentication();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          title: Text(widget.data['data']['first_name']+" "+widget.data['data']['last_name']),
        ),
        body: Container(
          child: Column(
            children: [
              FlatButton(
                child: Text("Logout"),
                onPressed: (){
                  auth.stopAuthentication();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyHomePage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Error extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: Text("Authentication Failed",style: TextStyle(color:Colors.white),),
      ),
    );
  }
}
