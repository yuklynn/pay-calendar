import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';
import '../../types/MemoType.dart';

class CreateMemoModel with ChangeNotifier {
  late TextEditingController titleController;
  late TextEditingController costController;
  late TextEditingController descriptionController;
  DateTime? date;

  CreateMemoModel() {
    titleController = TextEditingController();
    costController = TextEditingController();
    descriptionController = TextEditingController();

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
  }

  void save(BuildContext context) {
    final newMemo = MemoType(
      title: titleController.text,
      cost: costController.text.isNotEmpty
          ? int.parse(costController.text.replaceAll(',', ''))
          : null,
      date: date,
      description: descriptionController.text,
    );
    Navigator.pop(context, newMemo);
  }

  void selectDate(BuildContext context) async {
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

    if (newDate != null) {
      date = newDate;
      try {
        notifyListeners();
      } catch (_) {}
    }
  }

  void deleteDate() {
    date = null;
    try {
      notifyListeners();
    } catch (_) {}
  }

  @override
  void dispose() {
    titleController.dispose();
    costController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

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
  ) {
    return ChangeNotifierProvider(
      create: (_) => CreateMemoModel(),
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
