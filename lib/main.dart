import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'status.dart';
import 'card.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness _platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

  final Color fallbackSeedColor = Colors.deepPurple;

  ColorScheme _getColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: fallbackSeedColor,
      brightness: brightness,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    });
  }

@override
Widget build(BuildContext context) {
  return DynamicColorBuilder(
    builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    debugPrint("🌈 lightDynamic: $lightDynamic");
    debugPrint("🌙 darkDynamic: $darkDynamic");
      final lightColorScheme = lightDynamic ?? _getColorScheme(Brightness.light);
      final darkColorScheme = darkDynamic ?? _getColorScheme(Brightness.dark);
      final useDark = _platformBrightness == Brightness.dark;

      return MaterialApp(
        title: 'FMAC',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: lightColorScheme.surface,
            foregroundColor: lightColorScheme.onSurface,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: lightColorScheme.surface,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: darkColorScheme.surface,
            foregroundColor: darkColorScheme.onSurface,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: darkColorScheme.surface,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
          ),
        ),
        themeMode: useDark ? ThemeMode.dark : ThemeMode.light,
        home: const MyHomePage(title: 'FMAC'),
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
  SettingsPage(),
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
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
  String _SELinuxStatus = 'Loading';
  String _Fingerprint = 'Loading';

  @override
  void initState() {
    super.initState();
    _loadKernelVersion();
    _getSELinuxStatusFallback();
    _getBuildFingerprint();
  }

  Future<void> _loadKernelVersion() async {
    final version = await getKernelVersion();
    setState(() {
      _kernelVersion = version;
    });
  }

  Future<void> _getBuildFingerprint() async {
    final version = await getBuildFingerprint();
    setState(() {
      _Fingerprint = version;
    });
  }

  Future<void> _getSELinuxStatusFallback() async {
    final version = await getSELinuxStatusFallback();
    setState(() {
      _SELinuxStatus = version;
    });
  }

  Future<void> launchWebUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Can\'t open $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          InfoCard(
            title: '内核版本',
            children: [
              Text(_kernelVersion),
              const SizedBox(height: 16),
              Text('系统指纹', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(_Fingerprint),
              const SizedBox(height: 16),
              Text('SELinux 状态', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(_SELinuxStatus),
            ],
          ),
          InfoCard(
            title: '支持开发',
            children: [
              Text('KernelSU 将保持免费开源，向开发者捐赠以表示支持。'),
            ],
          ),
          InfoCard(
            title: '了解 KernelSU',
            children: [
              Text('了解如何安装 KernelSU 以及如何开发模块'),
            ],
            onTap: () {
              launchWebUrl('https://github.com/aqnya/fmanager');
            },
          ),
        ],
      ),
    );
  }
}