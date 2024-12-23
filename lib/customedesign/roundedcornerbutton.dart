import 'package:flutter/material.dart';

import 'colorfile.dart';

class RoundedCornerButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double thickness;

  const RoundedCornerButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.color,
    this.thickness = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: child,
    );
  }
}
