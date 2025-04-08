import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  final String description;
  const DescriptionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: EdgeInsets.all(16),
       // child: SingleChildScrollView(
    child:
    Text(
          description,
      textAlign: TextAlign.justify,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black.withAlpha(200)),
        ));
  }
}
