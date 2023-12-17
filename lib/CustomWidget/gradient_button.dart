import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget{
  final String title;
  final VoidCallback onTab;
  var width;
  var height;
  bool loading;
  bool isColor;


  GradientButton({required this.title,required this.onTab,this.width=150.0,this.height=50.0,this.loading = false,this.isColor=false}){

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
          width: width,
          height: height,
          child: Center(child: loading ? CircularProgressIndicator(color: Colors.white,strokeWidth: 3,) :
          Text(title,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [isColor? Colors.red.shade300:Colors.lime.shade500, isColor? Colors.red.shade300:Colors.green],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          )
      ),
    );
  }

}