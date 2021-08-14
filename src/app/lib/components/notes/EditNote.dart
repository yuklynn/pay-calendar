import 'package:flutter/material.dart';

import '../../models/notes/EditNoteModel.dart';
import '../../types/NoteType.dart';
import '../../util/colors.dart';
import '../common/CommonAppBar.dart';
import '../common/DisableScrollGlow.dart';

/// ノート編集画面
class EditNote extends StatelessWidget {
  final NoteType note;

  EditNote({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return EditNoteModel.provider(
      (
        nameController,
        color,
        descriptionController,
        showColorChoice,
        save,
      ) =>
          _EditNote(
        note: note,
        nameController: nameController,
        color: color,
        descriptionController: descriptionController,
        showColorChoice: showColorChoice,
        save: save,
      ),
      note,
    );
  }
}

class _EditNote extends StatelessWidget {
  final NoteType note;
  final TextEditingController nameController;
  final int color;
  final TextEditingController descriptionController;
  final VoidCallback showColorChoice;
  final VoidCallback save;

  _EditNote({
    required this.note,
    required this.nameController,
    required this.color,
    required this.descriptionController,
    required this.showColorChoice,
    required this.save,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  /// ヘッダー
  AppBar _buildAppBar() {
    return CommonAppBar(
      title: Text('Edit Note'), // todo:
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: nameController.text.isNotEmpty ? save : null,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ), // todo:
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final list = <Widget>[
      _buildNameFld(context),
      _buildColorFld(context),
      _buildDescriptionFld(),
    ];

    return DisableScrollGlow(
      child: ListView.separated(
        itemCount: list.length,
        itemBuilder: (context, index) => list[index],
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  /// ノート名入力
  Widget _buildNameFld(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: nameController,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(
          hintText: 'Name', // todo:
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// 色選択
  Widget _buildColorFld(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 12.0,
        backgroundColor: Color(color),
      ),
      title: Text(ThemeColorExtension.getName(color)),
      onTap: showColorChoice,
    );
  }

  /// 説明入力
  Widget _buildDescriptionFld() {
    return ListTile(
      leading: const Icon(Icons.notes),
      title: TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: 'About note', // todo:
          border: InputBorder.none,
        ),
        maxLines: null,
      ),
    );
  }
}
