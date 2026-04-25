import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors_manager/colors_manager.dart' show ColorsManager;

abstract class DialogApp{
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(
                  "loading",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 static void showErrorUi({required BuildContext context, required String error}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Error"),
        content: Text(
          error,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}