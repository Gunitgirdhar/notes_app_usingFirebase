import 'package:flutter/material.dart';

class  TextFeildDecoration {
  static InputDecoration getCustomDecoration({
    String hint="",
    required String labelText,
    IconData? mPrefixIcon,
    IconData? mSuffixIcon,
    Color suffixcolor=Colors.black,
    Color preffixcolor=Colors.black,
    VoidCallback? onSuffixIconTap,
  }){
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300),
      label: Text(labelText,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
      suffixIcon: mSuffixIcon != null ? InkWell(child: Icon(mSuffixIcon,color: suffixcolor,),onTap: onSuffixIconTap,) : null,
      prefixIcon: mPrefixIcon != null ? Icon(mPrefixIcon,color: preffixcolor,) : null,
      contentPadding: EdgeInsets.only(bottom: 8),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green,width: 2),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green,width: 2),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300,width: 2),
      ),


    );
  }
}