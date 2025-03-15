// lib/widgets/common/localized_text.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/localization_manager.dart';
import '../../localization/app_strings.dart';

class LocalizedText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText({
    Key? key,
    required this.textKey,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationManager>(
      builder: (context, localizationManager, _) {
        final text = AppStrings.get(textKey);
        final effectiveTextAlign = textAlign ?? 
            (localizationManager.isRTL ? TextAlign.right : TextAlign.left);
            
        return Text(
          text,
          style: style,
          textAlign: effectiveTextAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

class LocalizedRichText extends StatelessWidget {
  final List<LocalizedTextSpan> textSpans;
  final TextAlign? textAlign;
  final TextStyle? style;

  const LocalizedRichText({
    Key? key,
    required this.textSpans,
    this.textAlign,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationManager>(
      builder: (context, localizationManager, _) {
        final effectiveTextAlign = textAlign ?? 
            (localizationManager.isRTL ? TextAlign.right : TextAlign.left);
            
        return RichText(
          textAlign: effectiveTextAlign,
          text: TextSpan(
            style: style ?? DefaultTextStyle.of(context).style,
            children: textSpans.map((span) {
              return TextSpan(
                text: span.isKey ? AppStrings.get(span.text) : span.text,
                style: span.style,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class LocalizedTextSpan {
  final String text;
  final TextStyle? style;
  final bool isKey;

  const LocalizedTextSpan({
    required this.text,
    this.style,
    this.isKey = true,
  });
}

class LocalizedDirectionality extends StatelessWidget {
  final Widget child;

  const LocalizedDirectionality({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationManager>(
      builder: (context, localizationManager, _) {
        return Directionality(
          textDirection: localizationManager.textDirection,
          child: child,
        );
      },
    );
  }
}