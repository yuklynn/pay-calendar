import 'package:flutter/material.dart';

import '../components/calendar/CalendarBody.dart';
import '../components/common/CommonAppBar.dart';

/// カレンダー画面
class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text('Calendar'),
      ),
      body: CalendarBody(),
    );
  }
}
