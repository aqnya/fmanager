import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'status.dart';
import 'card.dart';
import 'settings.dart';
import 'mcl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final seedColor = await AccentColorFetcher.getAccentColor();
  runApp(MyApp(seedColor));
}

class MyApp extends StatefulWidget {
  final Color seedColor;
  const MyApp(this.seedColor, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness _platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

  ColorScheme _getColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: widget.seedColor,
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
    final lightColorScheme = _getColorScheme(Brightness.light);
    final darkColorScheme = _getColorScheme(Brightness.dark);
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
            systemNavigationBarColor: lightColorScheme.surfaceVariant,
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
            systemNavigationBarColor: darkColorScheme.surfaceVariant,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        ),
      ),
      themeMode: useDark ? ThemeMode.dark : ThemeMode.light,
      home: const MyHomePage(title: 'FMAC'),
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

final List<Widget> _pages = [
  const KernelSUHomePageContent(),
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
  PopupMenuButton<String>(
    icon: const Icon(Icons.restart_alt), // 自定义图标
    tooltip: '重启选项',
    onSelected: (String value) {
      switch (value) {
        case 'reboot':
          break;
        case 'recovery':
          break;
        case 'bootloader':
          break;
        case 'download':
          break;
        case 'edl':
          break;
      }
    },
    itemBuilder: (BuildContext context) => const [
      PopupMenuItem(
        value: 'reboot',
        child: Text('重启'),
      ),
      PopupMenuItem(
        value: 'recovery',
        child: Text('重启到 Recovery'),
      ),
      PopupMenuItem(
        value: 'bootloader',
        child: Text('重启到 BootLoader'),
      ),
      PopupMenuItem(
        value: 'download',
        child: Text('重启到 Download'),
      ),
      PopupMenuItem(
        value: 'edl',
        child: Text('重启到 EDL'),
      ),
    ],
  ),
],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  backgroundColor: colorScheme.surfaceVariant,
  selectedItemColor: colorScheme.primary,
  unselectedItemColor: colorScheme.onSurfaceVariant,
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
              Text('FMAC 将保持免费开源，向开发者捐赠以表示支持。'),
            ],
          ),
          InfoCard(
            title: '了解 FMAC',
            children: [
              Text('了解如何使用 FMAC'),
            ],
            onTap: () async {
  try {
    await launchWebUrl('https://github.com/aqnya/fmanager');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('无法打开链接: $e')),
    );
  }
},
          ),
        ],
      ),
    );
  }
}