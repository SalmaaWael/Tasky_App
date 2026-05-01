import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/auth/register_screen.dart';
import 'package:tasky_app/core/assets_manager/assets_manager.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';
import 'package:tasky_app/core/utils/dialog_app.dart';
import 'package:tasky_app/screens/home/home_screen.dart';

import '../widgets/material_button_widget.dart';
import '../widgets/text_form_feild_widget.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const String routeName= "LoginScreen";
  var email = TextEditingController();
  var password = TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff252525),
                  ),
                ),
                Text(
                  "sign in to access your account",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff252525),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                Text("Email",style:
                  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.textLargeColor
                  ),),

                SizedBox(height: 12),

                TextFormFeild(
                  controller: email,
                  hintText: "Enter your Email",
                  validator: (value){
                  if(value==null||value.isEmpty){
                    return"Please enter you Email";
                  }
                  },
                ),
                SizedBox(height: 30),
                Text("Password",style:
                TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.textLargeColor
                ),),
                SizedBox(height: 12),

                TextFormFeild(
                  controller: password,
                  hintText: "Enter your Password",
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return"Please enter you Password";
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButtonWidget(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  login(email: email.text.trim(), password: password.text, context: context);
                }
              },
              label: "Login >",
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New Member?",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>RegisterScreen())
                    );
                  },
                  child: Text(
                    "Register Now",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xffFF3951),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void login({required String email, required String password,required BuildContext context})async{
    DialogApp.showLoading(context);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      Navigator.pop(context);
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        DialogApp.showErrorUi(context: context, error: 'Invalid email or password.');
      } else if (e.code == 'invalid-email') {
        DialogApp.showErrorUi(context: context, error: 'The email address is badly formatted.');
      } else {
        DialogApp.showErrorUi(context: context, error: e.message ?? 'An error occurred.');
      }
    }
    catch(e){
      Navigator.of(context).pop();

      DialogApp.showErrorUi(context: context, error: e.toString());
    }
}
}
