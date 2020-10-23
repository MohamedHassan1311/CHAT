import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chathome.dart';
import 'package:chatapp/widget/custom_textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper/helperfunctions.dart';

class LogInScreen extends StatefulWidget {
  static String id = "/login";

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final loginKey = GlobalKey<FormState>();

  String _email, _password, _name;

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  bool _isLogIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//              image: AssetImage("assets/images/loginBG.jpg"),
//              fit: BoxFit.cover),
//        ),
        child: Container(
          child: Form(
            key: loginKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Welcome.... ",
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.purple,
                                    fontFamily: "Pacifico"),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 2,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Let`s Start Login Now!!",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontFamily: "Pacifico"),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: <Widget>[
                      if (_isLogIn != true)
                        CtextField(
                          Controller: usernameEditingController,
                          txtIcon: Icons.person,
                          hint: "Enter Your Name",
                          TextValue: (x) {
                            _name = x;
                          },
                        ),
                      if (_isLogIn != true)
                        SizedBox(
                          height: 5,
                        ),
                      CtextField(
                        Controller: emailEditingController,
                        txtIcon: Icons.email,
                        hint: "Enter Your Email",
                        TextValue: (x) {
                          _email = x;
                        },
                        KeyType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CtextField(
                        Controller: passwordEditingController,
                        txtIcon: Icons.lock_outline,
                        hint: "Enter Your Password",
                        TextValue: (x) {
                          _password = x;
                        },
                        KeyType: TextInputType.visiblePassword,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 120),
                    child: Builder(
                      builder: (context) => RaisedButton(
                        child: Text(
                          _isLogIn == true ? "Log in" : "Sign Up",
                          style: TextStyle(fontSize: 20, letterSpacing: 1),
                        ),
                        onPressed: () async {
                          if (_isLogIn == true) {
                            await _login(context);
                          } else {
                            await _SingUp(context);
                          }
                        },
                        color: Colors.white54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don`t have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogIn = !_isLogIn;
                        });
                      },
                      child: Text(
                        _isLogIn == true ? "Sign Up" : "Log In",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _SingUp(context) async {
    if (loginKey.currentState.validate()) {
      AuthService authService = new AuthService();
      DatabaseMethods databaseMethods = new DatabaseMethods();
      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text,
            "userEmail": emailEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  _login(BuildContext context) async {
    if (loginKey.currentState.validate()) {
      AuthService authService = new AuthService();

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {}
      });
    }
  }

//  void _login(BuildContext context) async {
//    FocusScope.of(context).unfocus();
//    loginKey.currentState.save();
//
//    if (loginKey.currentState.validate()) {
//      try {
//        await auth.signIn(_email.trim(), _password.trim());
//        QuerySnapshot userInfoSnapshot = await auth.getUserInfo(_email.trim());
//        SavedData.saveUserNameSharedPreference(
//            userInfoSnapshot.documents[0].data[UserName]);
//
//        SavedData.saveUserEmailSharedPreference(
//            userInfoSnapshot.documents[0].data[UserEmail]);
//
//        modelhud.ChangeIsLoding(true);
//        Navigator.pushReplacementNamed(context, HomeScreen.id);
//        loginStat.saveData(true);
//      } on PlatformException catch (e) {
//        Scaffold.of(context).showSnackBar(SnackBar(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(20),
//            side: BorderSide(color: Colors.black, style: BorderStyle.solid),
//          ),
//          duration: Duration(seconds: 5),
//          backgroundColor: Colors.white54,
//          content: Text(
//            e.message,
//            style: TextStyle(color: Colors.black),
//          ),
//        ));
//      }
//
//      modelhud.ChangeIsLoding(false);
//    }
//    modelhud.ChangeIsLoding(false);
//  }
//
//  Future _SingUp(BuildContext context) async {
//    FocusScope.of(context).unfocus();
//    final modelHud = Provider.of<ModelHud>(context, listen: false);
//    modelHud.ChangeIsLoding(true);
//    if (loginKey.currentState.validate()) {
//      try {
//        loginKey.currentState.save();
//        final autthresult = await auth.signUp(_email, _password, _name);
//        modelHud.ChangeIsLoding(true);
//        setState(() {
//          // ignore: unnecessary_statements
//          _isLogIn = true;
//        });
//      } catch (e) {
//        Scaffold.of(context).showSnackBar(
//          SnackBar(
//            content: Text(e.message),
//          ),
//        );
//      }
//    }
//    modelHud.ChangeIsLoding(false);
//  }
}
