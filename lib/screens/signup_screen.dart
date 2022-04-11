import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery/firebase/auth.dart';
import 'package:image_gallery/screens/loading_screen.dart';
import 'package:image_gallery/services/shared_items.dart';

class SignUpScreen extends StatefulWidget {
  final Function? changePage;
  const SignUpScreen({Key? key, this.changePage}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool showPassword = false;

  String email = '';
  String password = '';
  String userName = '';

  @override
  Widget build(BuildContext context) {
    final changePage = widget.changePage!();
    return loading ? Loading() : Scaffold(
      body:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_outlined),
                      SizedBox(height: 10),
                      Text("Welcome!")
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
                        Text("Username"),
                        SizedBox(height: 5),
                        TextFormField(
                          validator: (val) =>
                          val!.isEmpty ? "Enter a Username" : null,
                          onChanged: (val) {
                            setState(() {
                              userName = val;
                            });
                          },
                          decoration: textInputDecoration.copyWith(
                              hintText: "Swiftie"),
                        ),
                        SizedBox(height: 10),
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
                                Fluttertoast.showToast(msg: "Logged in");
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                await _auth.regWithEmailPassword(email, password, userName);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
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
                            child: Text("Create Account"),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Got an account? "),
                              GestureDetector(
                                  onTap: () {changePage();},
                                  child: Text(
                                    "Login here",
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
      ),
    );
  }
}
