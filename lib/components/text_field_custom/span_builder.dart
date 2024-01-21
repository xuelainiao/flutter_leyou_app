import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:mall_community/components/icon_svg/icon_svg.dart';

class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle, {this.start})
      : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;
  @override
  InlineSpan finishText() {
    final String name = toString().substring(1, toString().length - 1);
    if (isEmoji(name)) {
      return ExtendedWidgetSpan(
        actualText: toString(),
        start: start!,
        child: AlIconSvg(
          name: name,
          size: 20,
        ),
      );
    } else {
      return TextSpan(text: toString());
    }
  }

  isEmoji(String name) {
    var index = svgIcons.indexWhere((item) => item['name'] == name);
    return index != -1;
  }
}

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({this.showAtBackground = false});

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle, start: index! - (EmojiText.flag.length - 1));
    }

    /// 下面是目前项目暂时没用到的 后面可能会有
    //  else if (isStart(flag, ImageText.flag)) {
    //   return ImageText(textStyle,
    //       start: index! - (ImageText.flag.length - 1), onTap: onTap);
    // } else if (isStart(flag, AtText.flag)) {
    //   return AtText(
    //     textStyle,
    //     onTap,
    //     start: index! - (AtText.flag.length - 1),
    //     showAtBackground: showAtBackground,
    //   );
    // } else if (isStart(flag, EmojiText.flag)) {
    //   return EmojiText(textStyle, start: index! - (EmojiText.flag.length - 1));
    // } else if (isStart(flag, DollarText.flag)) {
    //   return DollarText(textStyle, onTap,
    //       start: index! - (DollarText.flag.length - 1));
    // }
    return null;
  }
}
