import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:mall_community/components/text_field_custom/span_builder.dart';
import 'custom_field_module.dart';

/// 文本输入框扩展 支持特殊符号转义
class FieldCustom extends StatelessWidget {
  const FieldCustom({
    super.key,
    required this.controller,
    this.inputDecoration,
    this.change,
    this.focusNode,
  });

  /// 文本框控制器
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;
  final Function(String)? change;

  @override
  Widget build(BuildContext context) {
    MySpecialTextSpanBuilder mySpecialTextSpanBuilder =
        MySpecialTextSpanBuilder();

    return ExtendedTextField(
      key: CustomFieldModule.key,
      focusNode: focusNode,
      maxLines: 4,
      minLines: 1,
      controller: controller,
      specialTextSpanBuilder: mySpecialTextSpanBuilder,
      strutStyle: const StrutStyle(),
      decoration: inputDecoration,
      onChanged: (tx) {
        change?.call(tx);
      },
    );
  }
}
