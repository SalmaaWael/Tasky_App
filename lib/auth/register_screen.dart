import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/colors_manager/colors_manager.dart';
import '../core/utils/dialog_app.dart';
import '../widgets/material_button_widget.dart';
import '../widgets/text_form_feild.dart';
import 'dart:developer';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  static const String routeName = "RegisterScreen";

  var email = TextEditingController();
  var password = TextEditingController();
  var repassword = TextEditingController();
  var name = TextEditingController();
  var phone = TextEditingController();
  var formKey = GlobalKey<FormState>();

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
                  "Register",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff252525),
                  ),
                ),
                Text(
                  "by creating a free account.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xff252525),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80),
                Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.textLargeColor,
                  ),
                ),
                SizedBox(height: 12),
                TextFormFeild(
                  controller: name,
                  hintText: "Enter your Username",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter you Username";
                    }
                  },
                ),
                SizedBox(height: 12),
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.textLargeColor,
                  ),
                ),
                SizedBox(height: 12),

                TextFormFeild(
                  controller: email,
                  hintText: "Valid Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter you Email";
                    }
                  },
                ),
                SizedBox(height: 12),
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.textLargeColor,
                  ),
                ),

                SizedBox(height: 12),
                TextFormFeild(
                  controller: password,
                  hintText: "password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter you Password";
                    }
                  },
                ),
                SizedBox(height: 12),
                Text(
                  "Confirm Password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.textLargeColor,
                  ),
                ),

                SizedBox(height: 12),
                TextFormFeild(
                  controller: repassword,
                  hintText: "Confirm Password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm you Password";
                    }
                  },
                ),
                Row(children: []),
                SizedBox(height: 200),
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
                  register(
                    email: email.text.trim(),
                    password: password.text,
                    context: context,
                  );
                }
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context)=>AppSectionView())
                // );
              },
              label: "Register >",
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a Member?",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Login",
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

  void register({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    DialogApp.showLoading(context);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        DialogApp.showErrorUi(
          context: context,
          error: "The password provided is too weak.",
        );
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        DialogApp.showErrorUi(
          context: context,
          error: "The account already exists for that email.",
        );
      }
    } catch (e) {
      Navigator.of(context).pop();

      DialogApp.showErrorUi(
        context: context,
        error: "The account already exists for that email.",
      );

      log(e.toString());
    }
  }


}
