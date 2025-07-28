// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fmanager/main.dart';

void main() {
  testWidgets('Bottom navigation switches pages', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // 验证初始显示为“首页内容”
    expect(find.text('首页内容'), findsOneWidget);
    expect(find.text('设置页面'), findsNothing);

    // 点击“设置”按钮
    await tester.tap(find.text('设置'));
    await tester.pump();

    // 验证现在显示的是“设置页面”
    expect(find.text('设置页面'), findsOneWidget);
    expect(find.text('首页内容'), findsNothing);
  });
}