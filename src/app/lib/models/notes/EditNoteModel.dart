import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../actions/common/navigation.dart';
import '../../actions/notes/isar_wrapper.dart';
import '../../types/NoteType.dart';

/// ノート変更画面のModel
class EditNoteModel with ChangeNotifier {
  final NoteType note; // ノート
  late TextEditingController nameController; // 名前入力欄のコントローラー
  late int color; // 色
  late TextEditingController descriptionController; // 説明入力欄のコントローラー

  /// コンストラクタ
  EditNoteModel({
    required this.note,
  }) {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() {
    // コントローラー作成
    nameController = TextEditingController(text: note.title);
    descriptionController = TextEditingController(text: note.description);

    // 入力ごとに変更を検知する
    nameController.addListener(() {
      try {
        notifyListeners();
      } catch (_) {}
    });
    descriptionController.addListener(() {
      try {
        notifyListeners();
      } catch (_) {}
    });

    // 色の初期化
    color = note.color;
  }

  @override
  void dispose() {
    // コントローラー破棄
    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  /// 色を選択する
  void chooseColor(BuildContext context) async {
    // 色選択のBottomSheetを表示
    final newColor = await showColorChoiceBottomSheet(context, color);
    if (newColor == null) return;

    // 選択した色に変更
    color = newColor;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// ノートの変更を保存する
  void save(BuildContext context) async {
    // ノートのデータ型に入力内容を保存
    final newNote = note.edit(
      title: nameController.text,
      color: color,
      description: descriptionController.text,
    );

    // ノートを変更する
    final result = await createOrUpdateNote(newNote);
    Navigator.pop(context, result != null);
  }

  /// Providerを取得する
  static Widget provider(
    Widget Function(
      TextEditingController,
      int,
      TextEditingController,
      VoidCallback,
      VoidCallback,
    )
        builder,
    NoteType note,
  ) {
    return ChangeNotifierProvider(
      create: (context) => EditNoteModel(note: note),
      builder: (context, _) {
        final model = context.watch<EditNoteModel>();
        return WillPopScope(
          child: builder(
            model.nameController,
            model.color,
            model.descriptionController,
            () => context.read<EditNoteModel>().chooseColor(context),
            () => context.read<EditNoteModel>().save(context),
          ),
          onWillPop: () async {
            Navigator.pop(context, false);
            return true;
          },
        );
      },
    );
  }
}
