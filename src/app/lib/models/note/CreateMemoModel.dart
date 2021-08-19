import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../types/MemoType.dart';
import '../../util/theme.dart';

/// メモ作成画面のModel
class CreateMemoModel with ChangeNotifier {
  MemoType? memo; // メモの情報(編集用)

  late TextEditingController titleController; // タイトル入力欄のコントローラー
  late TextEditingController costController; // コスト入力欄のコントローラー
  late TextEditingController descriptionController; // 説明入力欄のコントローラー
  DateTime? date; // 日付

  /// コンストラクタ
  CreateMemoModel({this.memo}) {
    // 初期処理
    _init();
  }

  /// 初期処理
  void _init() {
    // 値の初期化
    titleController = TextEditingController.fromValue(
      TextEditingValue(text: memo?.title ?? ''),
    );
    costController = TextEditingController.fromValue(
      TextEditingValue(
        text: (memo?.cost ?? '').toString(),
      ),
    );
    descriptionController = TextEditingController.fromValue(
      TextEditingValue(text: memo?.description ?? ''),
    );
    date = memo?.date;

    // 1文字ごとに入力を検知
    titleController.addListener(() {
      try {
        notifyListeners();
      } catch (_) {}
    });
    costController.addListener(() {
      try {
        notifyListeners();
      } catch (_) {}
    });
    descriptionController.addListener(() {
      try {
        notifyListeners();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    // コントローラーを破棄
    titleController.dispose();
    costController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  /// 保存ボタンを押したときの処理
  void save(BuildContext context) {
    // 入力内容をメモのデータ型に保存
    final newMemo = MemoType(
      id: memo?.id,
      title: titleController.text,
      cost: costController.text.isNotEmpty
          ? int.parse(costController.text.replaceAll(',', ''))
          : null,
      date: date,
      description: descriptionController.text,
    );

    Navigator.pop(context, newMemo);
  }

  /// 日付を選択する
  void selectDate(BuildContext context) async {
    // 日付選択を表示
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: MainTheme(context).theme.copyWith(
                colorScheme: ColorScheme.light().copyWith(
                  primary: MainTheme.primaryColor,
                  secondary: MainTheme.primaryColor,
                ),
              ),
          child: child!,
        );
      },
    );
    if (newDate == null) return;

    date = newDate;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// 選択した日付を削除する
  void deleteDate() {
    date = null;
    try {
      notifyListeners();
    } catch (_) {}
  }

  /// Providerを取得する
  static Widget provider(
    Widget Function(
      TextEditingController,
      TextEditingController,
      DateTime?,
      TextEditingController,
      VoidCallback,
      VoidCallback,
      VoidCallback,
    )
        builder,
    MemoType? memo,
  ) {
    return ChangeNotifierProvider(
      create: (_) => CreateMemoModel(memo: memo),
      builder: (context, _) {
        final model = context.watch<CreateMemoModel>();
        return builder(
          model.titleController,
          model.costController,
          model.date,
          model.descriptionController,
          () => context.read<CreateMemoModel>().save(context),
          () => context.read<CreateMemoModel>().selectDate(context),
          () => context.read<CreateMemoModel>().deleteDate(),
        );
      },
    );
  }
}
