import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/views/theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.title,
    this.hint,
    this.controller,
    this.suffixButton,
  }) : super(key: key);

  final String title;
  final String? hint;
  final TextEditingController? controller;
  final Widget? suffixButton;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingStyle4,
          ),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: TextFormField(
              minLines: 1,
              maxLines: 5,
              readOnly: suffixButton != null,
              autofocus: false,
              controller: controller,
              style: headingStyle5,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: headingStyle5.copyWith(
                    color: (title == 'Title' || title == 'Note')
                        ? Colors.grey
                        : Get.isDarkMode
                            ? Colors.white
                            : Colors.black),
                suffixIcon: suffixButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
