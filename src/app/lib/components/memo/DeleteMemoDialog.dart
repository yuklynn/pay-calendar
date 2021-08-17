import 'package:flutter/material.dart';

/// メモ削除ダイアログの表示Widget
class DeleteMemoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Delete this memo?'), // todo:
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
