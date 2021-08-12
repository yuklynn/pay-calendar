import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_calendar/actions/memo/navigation.dart';
import 'package:pay_calendar/database/controllers/MemoController.dart';

import '../../types/MemoType.dart';

class MemoCard extends StatelessWidget {
  final MemoType memo;
  static const _buttonSize = 24.0;
  static const _padding = 8.0;

  MemoCard({
    required this.memo,
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
            if (memo.cost != null) _buildPayment(theme.textTheme),
            if (memo.date != null) _buildDate(theme.textTheme),
            if (memo.description?.isNotEmpty ?? true)
              _buildDescription(theme.textTheme),
            Align(
              alignment: Alignment.centerRight,
              child: _buildPopupMenuButton(),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildPayment(TextTheme textTheme) {
    final text = NumberFormat('#,###').format(memo.cost);
    final style = textTheme.subtitle1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('¥', style: style),
        const SizedBox(width: 1.5),
        Text(text, style: style),
      ],
    );
  }

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

  Widget _buildDescription(TextTheme textTheme) {
    return Text(
      '${memo.description}',
      style: textTheme.caption,
    );
  }

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
              value: () => print('edit'),
            ),
            PopupMenuItem(
              child: Text('Delete'),
              value: () async {
                final result = await showDeleteMemoDialog(context);
                if (result) MemoController.delete(memo.id!);
              },
            ),
          ],
          onSelected: (callback) => callback(),
        ),
      ),
    );
  }
}
