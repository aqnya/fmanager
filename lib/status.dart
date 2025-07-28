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

Future<String> getSELinuxStatusFallback() async {
  try {
    final result = await Process.run('getenforce', []);
    final output = result.stdout.toString().trim();
    final error = result.stderr.toString().trim();

    if (result.exitCode == 0) {
      switch (output) {
        case 'Enforcing':
          return 'Enforcing';
        case 'Permissive':
          return 'Permissive';
        case 'Disabled':
          return 'Disabled';
        default:
          return '未知状态：$output';
      }
    } else {
      // 权限被拒绝时默认返回 Enforcing
      if (error.contains('Permission denied') || output.contains('Permission denied')) {
        return 'Enforcing';
      } else {
        return 'Unknown（exitCode: ${result.exitCode}, 错误: $error）';
      }
    }
  } catch (e) {
    return '不支持或出错：$e';
  }
}