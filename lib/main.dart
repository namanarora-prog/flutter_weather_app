import 'package:flutter/material.dart';
import './ui/Climate.dart';

void main(){
  runApp(MaterialApp(
    title: 'Weather',
    theme: ThemeData(fontFamily: 'norwester'
    ),
    home:climatic(),
  ));
}