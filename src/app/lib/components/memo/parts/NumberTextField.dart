import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;

  NumberTextField({
    required this.controller,
    this.hintText,
  });

  @override
  _NumberTextFieldState createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  String lastText = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(7),
      ],
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: InputBorder.none,
      ),
      onChanged: (text) {
        // テキストが空ならカーソル位置は最後尾
        if (text.isEmpty) {
          setState(() {
            lastText = text;
          });
          return;
        }
        // 桁が変わらないとき
        if (text.length == lastText.length) _onDigitRemain(text);
        // 桁が増えるとき
        if (text.length > lastText.length) _onDigitIncrease(text);
        // 桁が減るとき
        if (text.length < lastText.length) _onDigitDecrease(text);
      },
    );
  }

  /// 桁が増えるとき
  void _onDigitIncrease(String text) {
    // 先頭・末尾からのカーソル位置を取得
    final head = widget.controller.value.selection.baseOffset;
    final tail = text.length - head;

    // 数字をフォーマット
    final formatted = NumberFormat('#,###').format(int.parse(text));
    var offset = formatted.length - tail;

    // カーソルが先頭ならそのまま
    if (head == 0) {
      _onCursorHead(formatted);
      return;
    }

    // カーソルが最後尾ならそのまま
    if (tail == 0) {
      _onCursorTail(formatted);
      return;
    }

    // カンマが増えるなら一つ前にずらす
    if (formatted.length > text.length) {
      offset--;
    }

    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: min(offset, formatted.length),
      ),
    );

    setState(() {
      lastText = text;
    });
  }

  /// 桁が減るとき
  void _onDigitDecrease(String text) {
    // 先頭・末尾からのカーソル位置を取得
    final head = widget.controller.value.selection.baseOffset;
    final tail = text.length - head;

    // 数字をフォーマット
    final formatted = NumberFormat('#,###').format(int.parse(text));
    var offset = formatted.length - tail;

    // カーソルが先頭ならそのまま
    if (head == 0) {
      _onCursorHead(formatted);
      return;
    }

    // カーソルが最後尾ならそのまま
    if (tail == 0) {
      _onCursorTail(formatted);
      return;
    }

    // カンマの直後にカーソルが合わないようにする
    if (formatted[offset - 1] == ',') {
      offset--;
    }
    // カンマ付きのときはカーソルがずれないようにする
    else if (formatted.length >= 5 && tail > 3) {
      offset--;
    }

    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: min(offset, formatted.length),
      ),
    );

    setState(() {
      lastText = text;
    });
  }

  /// 桁が変わらないとき
  void _onDigitRemain(String text) {
    // 先頭・末尾からのカーソル位置を取得
    final head = widget.controller.value.selection.baseOffset;
    final tail = text.length - head;

    // 数字をフォーマット
    final formatted = NumberFormat('#,###').format(int.parse(text));
    var offset = formatted.length - tail;

    // カーソルが先頭ならそのまま
    if (head == 0) {
      _onCursorHead(formatted);
      return;
    }

    // カーソルが最後尾ならそのまま
    if (tail == 0) {
      _onCursorTail(formatted);
      return;
    }

    // カンマ付きのときはカーソルがずれないようにする
    if (formatted.length >= 5 && tail >= 3) {
      offset--;
    }

    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: min(offset, formatted.length),
      ),
    );

    setState(() {
      lastText = text;
    });
  }

  void _onCursorHead(String formatted) {
    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: 0,
      ),
    );

    setState(() {
      lastText = formatted.replaceAll(',', '');
    });
  }

  void _onCursorTail(String formatted) {
    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );

    setState(() {
      lastText = formatted.replaceAll(',', '');
    });
  }
}
