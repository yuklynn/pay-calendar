import 'package:flutter/material.dart';

import '../../types/NoteType.dart';
import '../common/CommonBottomSheet.dart';

/// ノート作成ボトムシート
class CreateNoteBottomSheet extends StatefulWidget {
  @override
  _CreateNoteBottomSheetState createState() => _CreateNoteBottomSheetState();
}

class _CreateNoteBottomSheetState extends State<CreateNoteBottomSheet> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      body: Column(
        children: [
          _buildHeader(),
          _buildBody(),
        ],
      ),
    );
  }

  /// ヘッダー
  Widget _buildHeader() {
    return ListTile(
      trailing: ElevatedButton(
        onPressed: nameController.text.isNotEmpty
            ? () {
                Navigator.pop(
                  context,
                  NoteType.noLoad(name: nameController.text),
                );
              }
            : null,
        child: Text('Save'), // todo:
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
        ),
      ),
    );
  }

  /// body部
  Widget _buildBody() {
    return ListTile(
      title: TextField(
        style: Theme.of(context).textTheme.headline5,
        controller: nameController,
        decoration: InputDecoration(
          hintText: 'Note name', // todo:
          border: InputBorder.none,
        ),
      ),
    );
  }
}
