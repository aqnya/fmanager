import 'package:flutter/material.dart';
import 'logcat.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      children: [
        const ListTile(
          title: Text('设置'),
          subtitle: Text('在此配置你的偏好'),
        ),
        const Divider(),

        ListTile(
          leading: const Icon(Icons.terminal),
          title: const Text('查看 Logcat 日志'),
          subtitle: const Text('用于调试模块、SELinux、Kernel 等输出'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogcatPage()),
            );
          },
        ),

        // 可添加更多设置项...
      ],
    );
  }
}