import 'dart:io';

Future<String> getKernelVersion() async {
  try {
    final result = await Process.run('uname', ['-r']);
    if (result.exitCode == 0) {
      return result.stdout.toString().trim();
    } else {
      return '获取失败: ${result.stderr}';
    }
  } catch (e) {
    return '异常: $e';
  }
}