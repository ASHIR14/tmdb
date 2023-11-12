import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {this.text,
      this.textWidget,
      this.onPressed,
      this.textStyle,
      this.fixedSize,
      this.minimumSize,
      this.backgroundColor,
      this.borderRadius,
      this.elevation,
      super.key});

  final String? text;
  final Widget? textWidget;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final MaterialStateProperty<Size?>? fixedSize;
  final MaterialStateProperty<Size?>? minimumSize;
  final Color? backgroundColor;
  final double? borderRadius;
  final MaterialStateProperty<double?>? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: fixedSize,
        minimumSize: minimumSize,
        backgroundColor:
            MaterialStateProperty.all(backgroundColor ?? AppColors.blueColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
        ),
        elevation: elevation,
      ),
      child: textWidget ??
          Text(
            text ?? "no text",
            style: textStyle ??
                TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
          ),
    );
  }
}
