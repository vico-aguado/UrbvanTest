import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urbvan/configuration.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onTap;
  final String title;
  final double width;
  final double height;
  final bool isOutline;
  final bool enabled;
  final double fontSize;
  final TextStyle style;
  final bool negative;
  final Color outlineColor;

  ButtonWidget({
    @required this.title,
    @required this.onTap,
    this.width,
    this.fontSize,
    this.isOutline = false,
    this.enabled = true,
    this.height = 42,
    this.style,
    this.negative = false,
    this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle _style = style ?? GoogleFonts.lato();
    double fontSizeTMP = fontSize ?? _style.fontSize;

    Color grey = Color.fromRGBO(0, 0, 0, 0.2);

    Color _outlineColor = outlineColor ?? Color.fromRGBO(21, 25, 32, 0.5);
    Color _outlineColorBorder = outlineColor ?? Color.fromRGBO(86, 103, 137, 0.26);

    return GestureDetector(
      onTap: () {
        if (enabled) {
          onTap();
        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: enabled
                ? isOutline
                    ? Colors.transparent
                    : negative
                        ? Colors.white
                        : red_light_color
                : grey,
            border: Border.all(
                color: enabled
                    ? isOutline
                        ? _outlineColorBorder
                        : Colors.transparent
                    : Colors.transparent)),
        child: Center(
          child: Text(title,
              style: enabled
                  ? isOutline
                      ? _style.copyWith(fontSize: fontSizeTMP, color: _outlineColor)
                      : _style.copyWith(fontSize: fontSizeTMP, color: negative ? red_dark_color : Colors.white)
                  : _style.copyWith(color: negative ? red_dark_color : Colors.white, fontSize: fontSizeTMP)),
        ),
      ),
    );
  }
}
