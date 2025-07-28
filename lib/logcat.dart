import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class LogcatPage extends StatefulWidget {
  const LogcatPage({super.key});

  @override
  State<LogcatPage> createState() => _LogcatPageState();
}

class _LogcatPageState extends State<LogcatPage> {
  final List<String> _logLines = [];
  final ScrollController _scrollController = ScrollController();
  Process? _logcatProcess;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startLogcat();
  }

  @override
  void dispose() {
    _logcatProcess?.kill();
    _scrollController.dispose();
    super.dispose();
  }

  void _startLogcat() async {
    setState(() => _isLoading = true);
    try {
      _logLines.clear();
      _logcatProcess = await Process.start(
        'logcat',
        ['-d'], // 使用 `-d` 获取现有日志；可换成 `-v` 选项增强格式
        runInShell: true,
      );

      _logcatProcess!.stdout.transform(SystemEncoding().decoder).listen((data) {
        setState(() {
          _logLines.addAll(data.split('\n').where((line) => line.trim().isNotEmpty));
        });

        // 自动滚动到底部
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      });

      await _logcatProcess!.exitCode;
    } catch (e) {
      setState(() {
        _logLines.add('日志获取失败: $e');
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _refresh() {
    _logcatProcess?.kill();
    _startLogcat();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logcat 日志'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logLines.isEmpty
              ? const Center(child: Text('暂无日志输出'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _logLines.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      child: Text(
                        _logLines[index],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}