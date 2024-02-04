import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mall_community/components/emoji_icon/icon_svg.dart';

/// 自定义文本支持替换特殊文本
class TextSpanEmoji extends StatelessWidget {
  TextSpanEmoji({
    super.key,
    required this.text,
    this.style = const TextStyle(fontSize: 14),
    this.onSelectionChanged,
  });
  final String text;
  final TextStyle style;
  final Function(SelectedContent?)? onSelectionChanged;

  final RegExp emojiRegex = RegExp(r'\[[^\]]+\]');
  final FocusNode focusNode = FocusNode();
  SelectableRegionState? state;
  SelectedContent? selectedContent;

  /// 取消选择
  closeSlect() {
    focusNode.unfocus();
  }

  ///全选
  selectAll() {
    state?.selectAll();
  }

  ///复制选择文本
  copy() async {
    try {
      await Clipboard.setData(
          ClipboardData(text: selectedContent?.plainText ?? ''));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      focusNode: focusNode,
      contextMenuBuilder: (context, SelectableRegionState regionState) {
        state = regionState;
        return const SizedBox();
      },
      onSelectionChanged: (SelectedContent? select) {
        selectedContent = select;
        onSelectionChanged?.call(select);
      },
      child: Text.rich(
        TextSpan(
          style: style.copyWith(
            textBaseline: TextBaseline.alphabetic,
          ),
          children: [
            ...getSpansWithEmojis(text),
          ],
        ),
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
