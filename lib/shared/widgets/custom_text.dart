import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,

    // --- Style base ---
    this.style,

    // --- Overrides ---
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,

    // --- Layout / behavior ---
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaleFactor,

    // --- AutoSizeText ---
    this.minFontSize = 12,
    this.stepGranularity = 1,
    this.presetFontSizes,

    // --- Misc ---
    this.locale,
    this.strutStyle,
    this.semanticsLabel,
  });

  final String text;

  /// Base style (usually from Theme)
  final TextStyle? style;

  /// Overrides
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;

  /// Layout
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? textScaleFactor;

  /// Auto size
  final double minFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;

  /// Other
  final Locale? locale;
  final StrutStyle? strutStyle;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    final mergedStyle = baseStyle.copyWith(
      color: color ?? baseStyle.color,
      fontSize: fontSize ?? baseStyle.fontSize,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
      fontStyle: fontStyle ?? baseStyle.fontStyle,
      letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
      wordSpacing: wordSpacing ?? baseStyle.wordSpacing,
      height: height ?? baseStyle.height,
      decoration: decoration ?? baseStyle.decoration,
    );

    return AutoSizeText(
      text,
      style: mergedStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaleFactor: textScaleFactor,
      minFontSize: minFontSize,
      stepGranularity: stepGranularity,
      presetFontSizes: presetFontSizes,
      locale: locale,
      strutStyle: strutStyle,
      semanticsLabel: semanticsLabel,
    );
  }
}
