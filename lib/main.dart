import 'package:flutter/material.dart';
import 'package:to_do_/home.dart';

void main(){
  runApp(Todo());
}

class Todo extends StatelessWidget {
   Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.teal[200],
         
      ),
      home: MyUi(),
    );
  }
}