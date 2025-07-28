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
    // 构建应用
    await tester.pumpWidget(const MyApp(Colors.deepPurple));
    expect(find.text('未安装'), findsOneWidget);



    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle(); // 等待动画完成

    
    expect(find.text('未安装'), findsNothing);
  });
}