import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery/firebase/auth.dart';
import 'package:image_gallery/screens/loading_screen.dart';
import 'package:image_gallery/services/shared_items.dart';

class LoginScreen extends StatefulWidget {
  final Function? changePage;
  const LoginScreen({Key? key, this.changePage}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool showPassword = false;

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_outlined, color: mainColor,),
                  SizedBox(height: 10),
                  Text("Welcome!", style: TextStyle(color: mainColor),)
                ],
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email"),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter An Email" : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                          hintText: "Hello@gmail.com"),
                    ),
                    SizedBox(height: 10),
                    Text("Password"),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            obscureText: showPassword ? false : true,
                            validator: (val) =>
                                val!.isEmpty ? "Enter a Password" : null,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            decoration: textInputDecoration.copyWith(
                                hintText: "Very Scary Password"),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye))
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            Fluttertoast.showToast(msg: "Logged in");
                            dynamic result =
                            await _auth.logInEmailPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = true;
                              });
                              Fluttertoast.showToast(msg: "Error");
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Fields are empty",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text("Login"),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("New here? "),
                          GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Create one",
                                style: TextStyle(color: Colors.blue),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    ) ;
  }
}
