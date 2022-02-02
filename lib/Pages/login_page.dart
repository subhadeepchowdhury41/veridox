import 'package:flutter/material.dart';
import 'package:veridox/Elements/submit_button.dart';
import 'package:veridox/Elements/text_input.dart';


<<<<<<< HEAD
=======

>>>>>>> 7443d58826d3d21af8a791c74f458e7c3d8d217b
class LogInPage extends StatefulWidget {
  const LogInPage({ Key? key }) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(30.0),
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 19,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(9.0),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0XFFC925E3),
                      Color(0XFF256CBF),
                    ]),
                ),
                child: Column(
                  children: [
                    const CustomTextInput(text: "Email", keyboardType: TextInputType.text, password: false),
                    const SizedBox(
                      height: 30,
                    ),
                    const CustomTextInput(text: "Phone Number", keyboardType: TextInputType.number, password: false),
                    const SizedBox(
                      height: 30,
                    ),
                    const CustomTextInput(text: "Password", keyboardType: TextInputType.text, password: true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0
                            ),
                            child: const Text("Forgot Password", style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    const SubmitButton(text: 'Log In'),
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
}