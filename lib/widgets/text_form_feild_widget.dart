import 'package:flutter/material.dart';

class TextFormFeild extends StatelessWidget {
  TextFormFeild({super.key,
    this.controller,
    this.hintText,
    this.validator,
  });
  TextEditingController? controller;
  String?hintText;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator ,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xffB7B7B7)
          ),
          fillColor: Color(0xffF3F3F3),
          filled: true,
          focusedBorder: _outlineInputBorder( Color(0xffFF3951)),
          enabledBorder: _outlineInputBorder(Colors.transparent)

      ),
    );

  }
  OutlineInputBorder _outlineInputBorder(Color color){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color:color),
    );
  }
}
