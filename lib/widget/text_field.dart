import 'package:flutter/material.dart';

const TextStyle hintStyle = TextStyle(color: Colors.white);
const TextStyle headline2 = TextStyle(color: Colors.white);

Widget textFild({
  required TextEditingController controller,
  required IconData icon,
  required TextInputType keyBordType,
  required String hintTxt,
  bool isObs = false,
  String? Function(String?)? validator,
  String? prefixText, // Add this line for prefix
}) {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 8), // Add some spacing between icon and prefix
        prefixText != null
            ? Text(
                prefixText,
                style: TextStyle(color: Colors.white),
              )
            : Container(),
        SizedBox(width: 8), // Add small space between prefix and hint text
        Expanded(
          child: TextFormField(
            obscureText: isObs,
            controller: controller,
            keyboardType: keyBordType,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintTxt,
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    ),
  );
}
