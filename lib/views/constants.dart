// constants.dart

import 'package:flutter/material.dart';

const IconData myStoreIcon = IconData(0xe800, fontFamily: 'IconlyBold');
const IconData myStoreIcon1 = IconData(0xe800, fontFamily: 'IconlyBold');

const TextStyle headline1 = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

class SpaceVH extends StatelessWidget {
  final double? width;
  final double? height;
  const SpaceVH({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height == null ? 0.0 : height,
      width: width == null ? 0.0 : width,
    );
  }
}

const TextStyle headline = TextStyle(
  fontSize: 28,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const TextStyle headlineDot = TextStyle(
  fontSize: 30,
  color: Colors.blue,
  fontWeight: FontWeight.bold,
);

const TextStyle headline2 = TextStyle(
  fontSize: 14,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);
const TextStyle headline3 = TextStyle(
  fontSize: 14,
  color: Colors.grey,
  fontWeight: FontWeight.bold,
);
const TextStyle hintStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
  fontWeight: FontWeight.bold,
);
