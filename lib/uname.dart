import 'dart:io';

Future<String> getKernelVersion() async {
  try {
    final file = File('/proc/version');
    if (await file.exists()) {
      final content = await file.readAsString();
      return content.trim();
    } else {
      return '无法访问 /proc/version';
    }
  } catch (e) {
    return '获取失败: $e';
  }
}