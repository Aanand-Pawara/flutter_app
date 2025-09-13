import 'package:flutter/material.dart';

class UIComponents {
  // ================================
  // Text helper
  // ================================
  static Widget createText(
    String text, {
    String fontFamily = "Outfit",
    bool withShadow = false,
    Color? color,
    Gradient? gradient,
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w800,
    TextAlign textAlign = TextAlign.center,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      color: gradient == null ? color : Colors.white,
      shadows: withShadow
          ? [
              Shadow(
                offset: Offset(-1, 1),
                blurRadius: 0,
                color: Colors.black45,
              ),
            ]
          : null,
    );

    final textWidget = Text(text, style: style, textAlign: textAlign);

    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: textWidget,
        blendMode: BlendMode.srcIn,
      );
    } else {
      return textWidget;
    }
  }

  // ================================
  // Modern button with gradient bg/text
  // ================================
  static Widget buildModernButton(
    String text, {
    Gradient? bgGradient,
    Gradient? textGradient,
    VoidCallback? onPressed,
  }) {
    Widget buttonChild = Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        fontFamily: "Outfit",
        color: Colors.white,
      ),
    );

    if (textGradient != null) {
      buttonChild = ShaderMask(
        shaderCallback: (bounds) => textGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: buttonChild,
        blendMode: BlendMode.srcIn,
      );
    }

    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: bgGradient,
        color: bgGradient == null ? Colors.deepPurple : null,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed ?? () {},
          child: Center(child: buttonChild),
        ),
      ),
    );
  }

  // ================================
  // Gradient TextField with icon, border, and text gradient when focused
  // ================================
  static Widget buildGradientTextField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool obscure = false,
    Gradient? borderGradient,
    Gradient? textGradient,
    Gradient? iconGradient,
    FocusNode? focusNode,
  }) {
    focusNode ??= FocusNode();

    return StatefulBuilder(
      builder: (context, setState) {
        focusNode!.addListener(() => setState(() {}));

        // Base TextField
        Widget textField = TextField(
          controller: controller,
          obscureText: obscure,
          focusNode: focusNode,
          cursorColor: Colors.black,
          style: TextStyle(
            color: focusNode!.hasFocus && textGradient == null
                ? Colors.black
                : null,
            fontFamily: "Outfit",
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: "Outfit",
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
            prefixIcon: iconGradient != null && focusNode!.hasFocus
                ? ShaderMask(
                    shaderCallback: (bounds) => iconGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Icon(icon, color: Colors.white),
                    blendMode: BlendMode.srcIn,
                  )
                : Icon(icon, color: Colors.grey),
          ),
        );

        // Wrap gradient border if focused
        if (borderGradient != null) {
          textField = Stack(
            children: [
              if (focusNode!.hasFocus)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 4,
                          color: Colors.transparent,
                        ), // THICK border
                        gradient: borderGradient,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(
                  2,
                ), // inside spacing for visible border
                child: textField,
              ),
            ],
          );
        }

        // Wrap text in ShaderMask if textGradient is provided
        if (textGradient != null && focusNode!.hasFocus) {
          textField = ShaderMask(
            shaderCallback: (bounds) => textGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: textField,
            blendMode: BlendMode.srcIn,
          );
        }

        return textField;
      },
    );
  }
}
