import 'package:flutter/material.dart';

import '../../ultis/constants.dart';
import '../../ultis/dimensions.dart';


class CustomInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const CustomInputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        Container(
          margin: EdgeInsets.only(top: Dimensions.height10),
          padding: EdgeInsets.only(
            left: Dimensions.width10,
            right: Dimensions.width10,
          ),
          height: Dimensions.height45,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: Dimensions.width1,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radius5 * 3),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  // ignore: unnecessary_null_comparison
                  readOnly: widget == null ? false : true,
                  autofocus: true,
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: subTitleStyle,
                    focusedBorder: InputBorder.none,
                    enabledBorder:InputBorder.none,
                  ),
                ),
              ),
              //Nếu widget là null thì trả về container , ngược lại trả về một container chứa widget
              widget == null
                  ? Container()
                  : Container(
                      child: widget,
                    ),
            ],
          ),
        )
      ],
    );
  }
}
