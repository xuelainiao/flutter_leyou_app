import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mall_community/components/text_field_custom/span_builder.dart';

/// 特殊输入框的控制器
class CustomFieldModule {
  static GlobalKey<ExtendedTextFieldState> key =
      GlobalKey<ExtendedTextFieldState>();

  static late TextEditingController controller;

  static final MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
      MySpecialTextSpanBuilder();

  /// 特殊文本插入
  static void insertText(String text) {
    final TextEditingValue value = controller.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      controller.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      controller.value = TextEditingValue(
          text: text,
          selection:
              TextSelection.fromPosition(TextPosition(offset: text.length)));
    }
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      key.currentState?.bringIntoView(controller.selection.base);
    });
  }

  /// 手动删除
  static void manualDelete() {
    //delete by code
    final TextEditingValue valuePrivate = controller.value;
    final TextSelection selection = valuePrivate.selection;
    if (!selection.isValid) {
      return;
    }

    TextEditingValue value;
    final String actualText = valuePrivate.text;
    if (selection.isCollapsed && selection.start == 0) {
      return;
    }

    final int start =
        selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;
    final CharacterRange characterRange =
        CharacterRange.at(actualText, start, end);
    value = TextEditingValue(
      text: characterRange.stringBefore + characterRange.stringAfter,
      selection:
          TextSelection.collapsed(offset: characterRange.stringBefore.length),
    );
    final TextSpan oldTextSpan =
        _mySpecialTextSpanBuilder.build(valuePrivate.text);
    value = ExtendedTextLibraryUtils.handleSpecialTextSpanDelete(
      value,
      valuePrivate,
      oldTextSpan,
      null,
    );
    controller.value = value;
  }
}
