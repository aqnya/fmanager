import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'uname.dart';

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
          title: 'KernelSU',
          theme: ThemeData(
            colorScheme: lightDynamic ?? fallbackLightColorScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: lightDynamic?.surface ?? fallbackLightColorScheme.surface,
              foregroundColor: lightDynamic?.onSurface ?? fallbackLightColorScheme.onSurface,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? fallbackDarkColorScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: darkDynamic?.surface ?? fallbackDarkColorScheme.surface,
              foregroundColor: darkDynamic?.onSurface ?? fallbackDarkColorScheme.onSurface,
            ),
          ),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: 'KernelSU'),
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

  final List<Widget> _pages = const [
    KernelSUHomePageContent(),
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
            label: '主页',
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

class KernelSUHomePageContent extends StatefulWidget {
  const KernelSUHomePageContent({super.key});

  @override
  State<KernelSUHomePageContent> createState() => _KernelSUHomePageContentState();
}

class _KernelSUHomePageContentState extends State<KernelSUHomePageContent> {
  String _kernelVersion = '加载中...';

  @override
  void initState() {
    super.initState();
    _loadKernelVersion();
  }

  Future<void> _loadKernelVersion() async {
    final version = await getKernelVersion();
    setState(() {
      _kernelVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 未安装卡片
          Card(
            color: colorScheme.errorContainer,
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
                      Text('未安装',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onErrorContainer)),
                      const SizedBox(height: 4),
                      Text('点击安装',
                          style: TextStyle(
                              fontSize: 14, color: colorScheme.onErrorContainer)),
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
                  Text(_kernelVersion),
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