import 'package:flutter/material.dart';

import '../../ultis/constants.dart';
import '../../ultis/dimensions.dart';


class CustomButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const CustomButton({Key? key, required this.label, required this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius20), color: kPrimaryColor),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: Dimensions.font16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
