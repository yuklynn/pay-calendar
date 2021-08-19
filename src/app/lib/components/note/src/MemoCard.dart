import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../types/MemoType.dart';
import '../../../util/functions.dart';

/// メモカードの表示Widget
class MemoCard extends StatelessWidget {
  final MemoType memo; // メモの情報
  final void Function(MemoType) edit; // メモを編集する
  final void Function(MemoType) delete; // メモを削除する
  static const _buttonSize = 24.0; // ボタンサイズ
  static const _padding = 8.0; // 余白サイズ

  /// コンストラクタ
  MemoCard({
    required this.memo,
    required this.edit,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.dividerColor, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(theme.textTheme),
            if (memo.cost != null) ...[
              const SizedBox(height: 4.0),
              _buildPayment(theme.textTheme),
            ],
            if (memo.date != null) ...[
              const SizedBox(height: 4.0),
              _buildDate(theme.textTheme),
            ],
            if (memo.description?.isNotEmpty ?? true) ...[
              const SizedBox(height: 4.0),
              _buildDescription(theme.textTheme),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: _buildPopupMenuButton(),
            ),
          ],
        ),
      ),
    );
  }

  /// タイトルをビルドする
  Widget _buildTitle(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDoneButton(),
        const SizedBox(width: 4.0),
        Expanded(
          child: Text(
            memo.title,
            style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  /// 完了ボタンをビルドする
  Widget _buildDoneButton() {
    return InkResponse(
      child: CircleAvatar(
        radius: _buttonSize / 2,
        child: const Icon(
          Icons.done,
          size: (_buttonSize - 4),
        ),
      ),
    );
  }

  /// 金額欄をビルドする
  Widget _buildPayment(TextTheme textTheme) {
    final style = textTheme.subtitle1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('¥', style: style),
        const SizedBox(width: 1.5),
        Text(formatNumber(memo.cost!), style: style),
      ],
    );
  }

  /// 日付欄をビルドする
  Widget _buildDate(TextTheme textTheme) {
    final text = DateFormat.yMMMMd().format(memo.date!);
    final style = textTheme.subtitle1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('@', style: style),
        const SizedBox(width: 1.5),
        Text(text, style: style),
      ],
    );
  }

  /// 説明欄をビルドする
  Widget _buildDescription(TextTheme textTheme) {
    return Text(
      '${memo.description}',
      style: textTheme.caption,
    );
  }

  /// ポップアップボタンをビルドする
  Widget _buildPopupMenuButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<VoidCallback>(
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: const Icon(Icons.more_horiz),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('Edit'),
              value: () => edit(memo),
            ),
            PopupMenuItem(
              child: Text('Delete'),
              value: () => delete(memo),
            ),
          ],
          onSelected: (callback) => callback(),
        ),
      ),
    );
  }
}
