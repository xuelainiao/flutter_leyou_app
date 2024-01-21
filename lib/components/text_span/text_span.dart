import 'package:flutter/material.dart';
import 'package:mall_community/components/icon_svg/icon_svg.dart';

/// 自定义文本支持替换特殊文本
class TextSpanEmoji extends StatelessWidget {
  TextSpanEmoji({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 14),
  });
  final String text;
  final TextStyle style;
  final RegExp emojiRegex = RegExp(r'\[[^\]]+\]');

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: style.copyWith(
          textBaseline: TextBaseline.alphabetic,
        ),
        children: [
          ...getSpansWithEmojis(text),
        ],
      ),
    );
  }

  /// 表情文本格式化
  List<InlineSpan> getSpansWithEmojis(String text) {
    final List<InlineSpan> spans = [];
    final List<String?> matches =
        emojiRegex.allMatches(text).map((match) => match.group(0)).toList();
    if (matches.isEmpty) {
      spans.add(
        TextSpan(text: text),
      );
    } else {
      final parts = text.split(emojiRegex);
      final maxIndex = matches.length - 1;

      for (int i = 0; i <= maxIndex; i++) {
        if (parts[i].isNotEmpty) {
          spans.add(
            TextSpan(text: parts[i]),
          );
        }

        if (i <= maxIndex) {
          final match = matches[i];
          if (match != null) {
            final emoji = match.substring(1, match.length - 1);
            spans.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: AlIconSvg(
                  name: emoji,
                  size: 30,
                ),
              ),
            );
          }
        }
      }

      if (parts.length > matches.length) {
        spans.add(
          TextSpan(text: parts[maxIndex + 1]),
        );
      }
    }
    return spans;
  }
}
