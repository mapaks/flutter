// ignore_for_file: use_key_in_widget_constructors, todo

import 'package:flutter/material.dart';
import 'dart:math';

//https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e

//This app makes use of the Row, Column,
//Expanded, Padding, Transform, Container,
//BoxDecoration, BoxShape, Colors,
//Border, Center, Align, Alignment,
//EdgeInsets, Text, and TextStyle Widgets
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //first level widget of Material Design
      home: Scaffold(
        //default route
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Text("App1 - UI Layout"),
          backgroundColor: Colors.blue,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //TODO: Put your code here to complete this app.
            Column(
              children: [
                Container(
                  height: 100, 
                  width: 100, 
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(color: Colors.black, width: 3)),
                    child: const Center(
                      child: Text("Container 1"),),),
                Transform.rotate(angle: pi / 4, child: Container(
                  height: 100, 
                  width: 100, 
                  decoration: const BoxDecoration(
                    color: Colors.white,),
                    child: const Center(
                      child: Text("Container 2"),),),),
              ],
            ),
            Column(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 100, 
                    width: 100, 
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      color: Colors.yellow,),
                      child: const Text("Container 3"),),),),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(10.0), 
                  child: Container(
                    height: 100, 
                    width: 100,
                    alignment: Alignment.centerRight,
                    decoration: const BoxDecoration(
                      color: Colors.blue,),
                      child: const Text("Container 4"),),),),
              ],
            ),
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 100, 
                    width: 100, 
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.circle),
                      child: const Center(
                        child: Text("Container 5", style: TextStyle(color: Colors.white),),),),),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100, 
                    width: 100, 
                    decoration: const BoxDecoration(
                      color: Colors.red,),
                      child: const Text("Con 6", style: TextStyle(fontSize: 30),),),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
