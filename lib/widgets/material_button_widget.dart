import 'package:flutter/material.dart';
import 'package:tasky_app/core/colors_manager/colors_manager.dart';

class MaterialButtonWidget extends StatelessWidget {
  MaterialButtonWidget({super.key,required this.label,this.onPressed});
  String label;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: ColorsManager.primaryColor,
      height: 48,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed:onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
