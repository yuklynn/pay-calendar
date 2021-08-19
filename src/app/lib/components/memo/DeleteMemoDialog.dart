import 'package:flutter/material.dart';

/// メモ削除ダイアログの表示Widget
class DeleteMemoDialog extends StatelessWidget {
  final String title;

  DeleteMemoDialog({required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1,
          children: [
            TextSpan(text: 'Delete '),
            TextSpan(
              text: title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: ' ?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            return Navigator.pop(context, false);
          },
          child: Text(
            'Cancel', // todo:
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            return Navigator.pop(context, true);
          },
          child: Text('Delete'), // todo:
        ),
      ],
    );
  }
}
