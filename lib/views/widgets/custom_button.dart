import 'package:flutter/material.dart';
import 'package:todo/views/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
            color: primaryClr,
            onPressed: onTap,
            child: Text(
              label,
              style: headingStyle4.copyWith(color: Colors.white),
            )),
      ),
    );
  }
}
