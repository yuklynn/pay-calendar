import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/note/CreateMemoModel.dart';
import '../../types/MemoType.dart';
import '../common/CommonAppBar.dart';
import '../common/DisableScrollGlow.dart';
import '../common/NumberTextField.dart';

/// メモ作成画面の表示Widget
class CreateMemo extends StatelessWidget {
  final MemoType? memo; // メモの情報(編集用)

  /// コンストラクタ
  CreateMemo({this.memo});

  @override
  Widget build(BuildContext context) {
    return CreateMemoModel.provider(
      (
        titleController,
        costController,
        date,
        descriptionController,
        save,
        selectDate,
        deleteDate,
      ) =>
          _CreateMemo(
        titleController: titleController,
        costController: costController,
        date: date,
        descriptionController: descriptionController,
        save: save,
        selectDate: selectDate,
        deleteDate: deleteDate,
      ),
      memo,
    );
  }
}

class _CreateMemo extends StatelessWidget {
  final TextEditingController titleController; // タイトル入力欄のコントローラー
  final TextEditingController costController; // 金額入力欄のコントローラー
  final TextEditingController descriptionController; // 説明入力欄のコントローラー
  final DateTime? date; // 日付
  final VoidCallback save; // 保存処理
  final VoidCallback selectDate; // 日付選択処理
  final VoidCallback deleteDate; // 選択した日付を削除する処理

  _CreateMemo({
    required this.titleController,
    required this.costController,
    required this.descriptionController,
    this.date,
    required this.save,
    required this.selectDate,
    required this.deleteDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  /// AppBarをビルド
  AppBar _buildAppBar() {
    return CommonAppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: titleController.text.isNotEmpty ? save : null,
            child: Text('Save'),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0.0),
            ), // todo:
          ),
        ),
      ],
    );
  }

  /// body部をビルド
  Widget _buildBody(BuildContext context) {
    final fields = <Widget>[
      _buildTitleFld(context),
      _buildCostFld(),
      _buildDateFld(context),
      _buildDescriptionFld(),
    ];

    return DisableScrollGlow(
      child: ListView.separated(
        itemCount: fields.length,
        itemBuilder: (context, index) => fields[index],
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  /// タイトル入力欄をビルド
  Widget _buildTitleFld(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: TextField(
        controller: titleController,
        style: theme.textTheme.headline6,
        decoration: InputDecoration(
          hintText: 'Title',
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// 金額入力欄をビルド
  Widget _buildCostFld() {
    return ListTile(
      leading: const Icon(Icons.payment),
      title: Row(
        children: [
          Text(
            '¥',
            style: TextStyle(
              color: costController.text.isEmpty ? Colors.grey : null,
            ),
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: NumberTextField(
              controller: costController,
              hintText: 'Payment',
            ),
          ),
        ],
      ),
    );
  }

  /// 日付入力欄をビルド
  Widget _buildDateFld(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: Text(
        date != null ? DateFormat.yMMMd().format(date!) : 'Deadline',
        style: TextStyle(
          color: theme.hintColor,
        ),
      ),
      trailing: date != null
          ? IconButton(
              onPressed: deleteDate,
              icon: const Icon(Icons.clear),
            )
          : null,
      onTap: selectDate,
    );
  }

  /// 説明入力欄をビルド
  Widget _buildDescriptionFld() {
    return ListTile(
      leading: const Icon(Icons.notes),
      title: TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: 'About memo',
          border: InputBorder.none,
        ),
        maxLines: null,
      ),
    );
  }
}
