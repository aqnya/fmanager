import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final Color fallbackSeedColor = Colors.deepPurple;

  static final ColorScheme fallbackLightColorScheme =
      ColorScheme.fromSeed(seedColor: fallbackSeedColor);

  static final ColorScheme fallbackDarkColorScheme =
      ColorScheme.fromSeed(seedColor: fallbackSeedColor, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'KernelSU', // 将标题更改为 KernelSU
          theme: ThemeData(
            colorScheme: lightDynamic ?? fallbackLightColorScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: lightDynamic?.surface ?? fallbackLightColorScheme.surface, // 使AppBar背景与页面背景色一致
              foregroundColor: lightDynamic?.onSurface ?? fallbackLightColorScheme.onSurface,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? fallbackDarkColorScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: darkDynamic?.surface ?? fallbackDarkColorScheme.surface, // 使AppBar背景与页面背景色一致
              foregroundColor: darkDynamic?.onSurface ?? fallbackDarkColorScheme.onSurface,
            ),
          ),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: 'KernelSU'), // 将标题更改为 KernelSU
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // 我们将在Scaffold的body中直接构建主页内容，以匹配图片。
  // _pages 列表现在只包含主页内容的单个条目。
  static const List<Widget> _pages = <Widget>[
    KernelSUHomePageContent(), // 为KernelSU屏幕创建的自定义小部件
    Center(child: Text('设置页面')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页', // 更改标签以匹配图片
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}

// KernelSU 主页内容的自定义小部件
class KernelSUHomePageContent extends StatelessWidget {
  const KernelSUHomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 未安装状态卡片
          Card(
            color: colorScheme.errorContainer, // 用于警告的醒目颜色
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: colorScheme.onErrorContainer),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '未安装', // Not installed
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onErrorContainer),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '点击安装', // Click to install
                        style: TextStyle(fontSize: 14, color: colorScheme.onErrorContainer),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 信息卡片
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('内核版本', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('5.15.167-android13-8-00014-gbf0a81a7f319-ab13297889'),
                  const SizedBox(height: 16),
                  Text('管理器版本', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('v1.0.5 (12081)'),
                  const SizedBox(height: 16),
                  Text('系统指纹', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('redmi/vermeer/vermeer:15/AQ3A.240912.001/\nOS2.0.208.0.VNKNXNM:user/release-keys'),
                  const SizedBox(height: 16),
                  Text('SELinux 状态', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('强制执行'),
                ],
              ),
            ),
          ),

          // 支持开发卡片
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('支持开发', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('KernelSU 将保持免费开源，向开发者捐赠以表示支持。'),
                ],
              ),
            ),
          ),

          // 了解更多卡片
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('了解 KernelSU', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('了解如何安装 KernelSU 以及如何开发模块'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
