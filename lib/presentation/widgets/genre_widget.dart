import 'package:flutter/material.dart';
import 'package:leeds_library/core/theme/app_colors.dart';

class GenreWidget extends StatelessWidget {
  final String genre;

  const GenreWidget({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return //SizedBox(
        //height: 24,
       // child:
        Container(
          color: AppColors.badgeColorBlue,
           child: Padding(
            padding: EdgeInsets.only(left: 10, right: 16, bottom: 3),

                child: Text(
              genre,
              style: TextStyle(color: Colors.white, fontSize: 12),
            )),

        );
    //);
  }
}
