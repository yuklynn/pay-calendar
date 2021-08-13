import 'package:flutter/material.dart';

import '../../components/Notes/Notes.dart';
import '../../components/calendar/Calendar.dart';
import '../../util/navigation_routes.dart';

/// カレンダーに移動する
Future<void> toCalendar(BuildContext context) async {
  await Navigator.push(
    context,
    NavigationRoute.forward(
      page: Calendar(),
    ),
  );
}

/// ノートに移動する
Future<void> toNotes(BuildContext context) async {
  await Navigator.push(
    context,
    NavigationRoute.forward(
      page: Notes(),
    ),
  );
}