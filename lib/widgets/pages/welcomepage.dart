import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return Container(
      width:double.infinity,
      height:double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
          Color.fromARGB(255, 3, 15, 1),
          Color.fromARGB(255, 2, 51, 33),
          ]
     ),
    ),
      child: Column(
        children: [
          SizedBox(height: 80,),
          Lottie.asset(
          'lib/widgets/lottie/welcomepage.json',
          ),
          FilledButton(onPressed: (){}, child: Text('Get Started',style: TextStyle(fontSize: 15, ),),
          style: FilledButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 16, 55, 40),//button color
            foregroundColor: Colors.white,//text color and icon color
            minimumSize: Size(200, 50), ///button size
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: BorderSide(
                color: const Color.fromARGB(255, 215, 198, 39), //border color
                width: 2, //border width
              ),
            ),
          ),) 
        ],
      ),
     );
  }
  
}