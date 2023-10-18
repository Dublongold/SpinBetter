import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.titleText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Logger().d("Logger is working");
                },
                icon: const Icon(Icons.settings)
            ),
          ),
          Align(
            alignment: Alignment.center,
            child:
            Text(titleText,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18
              ),),
          )
        ],
      )
      ,
    );
  }

  final String titleText;
}