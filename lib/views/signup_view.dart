import 'package:flutter/material.dart';
import 'package:mychatapp/services/auth.dart';
import 'package:mychatapp/views/main_view.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _name;
  AuthMethods authMethods = new AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(
          "Create a New Account",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  //name
                  validator: (input) {
                    return input.isEmpty ? 'Please type your name' : null;
                  },
                  controller: userNameTextEditingController,
                  style: TextStyle(color: Colors.white),
                  onSaved: (input) => _name = input,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white60),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      )),
                ),
                TextFormField(
                  //email
                  validator: (input) {
                    return input.isEmpty ? 'Please type an email' : null;
                  },
                  controller: emailTextEditingController,
                  style: TextStyle(color: Colors.white),
                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white60),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      )),
                ),
                TextFormField(
                  //password
                  validator: (input) {
                    return input.length < 6 ? 'Password is too short' : null;
                  },
                  controller: passwordTextEditingController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white60),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
          ),
          GestureDetector(
              onTap: () {
                signUp();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                //height: 55,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.deepOrange, Colors.deepOrangeAccent]),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  "CREATE",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              )),
        ]),
      ),
    );
  }

  void signUp() {
    final _formState = _formKey.currentState;
    try {
      if (_formState.validate()) {
        _formState.save();
        authMethods.signUp(_email, _password, _name).then((value) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false);
        });
      }
    } catch (e) {
      print("Error signUp_view");
    }
  }
}
