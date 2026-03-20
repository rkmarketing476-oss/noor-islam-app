import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/providers/tasbih_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/quran/quran_screen.dart';
import 'features/dua/dua_screen.dart';
import 'features/tasbih/tasbih_screen.dart';
import 'features/more/more_screen.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait + landscape on tablets, portrait only on small phones
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => TasbihProvider()),
      ],
      child: const NoorIslamApp(),
    ),
  );
}

class NoorIslamApp extends StatelessWidget {
  const NoorIslamApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'Noor Islam',
      debugShowCheckedModeBanner: false,
      themeMode: settings.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(settings.themeColor, settings.fontFamily),
      darkTheme: AppTheme.dark(settings.themeColor, settings.fontFamily),
      home: const MainScaffoldScreen(),
    );
  }
}

class MainScaffoldScreen extends StatefulWidget {
  const MainScaffoldScreen({super.key});

  @override
  State<MainScaffoldScreen> createState() => _MainScaffoldScreenState();
}

class _MainScaffoldScreenState extends State<MainScaffoldScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuranScreen(),
    DuaScreen(),
    TasbihScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final isDark = settings.isDark;
    final width = MediaQuery.of(context).size.width;

    // System UI overlay style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark ? AppColors.cardDark : Colors.white,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));

    final navItems = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded,
          label: strings.home),
      _NavItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book_rounded,
          label: strings.quran),
      _NavItem(icon: Icons.format_quote_outlined, activeIcon: Icons.format_quote_rounded,
          label: strings.dua),
      _NavItem(icon: Icons.loop_outlined, activeIcon: Icons.loop_rounded,
          label: strings.tasbih),
      _NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded,
          label: isBn ? 'আরও' : 'More'),
    ];

    // Tablet/Desktop: Navigation Rail
    if (width >= 768) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) => setState(() => _currentIndex = i),
              backgroundColor: isDark ? AppColors.cardDark : Colors.white,
              selectedIconTheme: IconThemeData(color: settings.themeColor),
              unselectedIconTheme: IconThemeData(color: AppColors.textMuted),
              selectedLabelTextStyle: TextStyle(
                color: settings.themeColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
              useIndicator: true,
              indicatorColor: settings.themeColor.withOpacity(0.12),
              extended: width >= 1100,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [settings.themeColor, settings.themeColor.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('☪️', style: TextStyle(fontSize: 20))),
                    ),
                    if (width >= 1100) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Noor Islam',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: settings.themeColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              destinations: navItems.map((item) => NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon),
                label: Text(item.label),
              )).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      );
    }

    // Mobile: Bottom Navigation Bar
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(navItems.length, (i) {
                final item = navItems[i];
                final isSelected = _currentIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentIndex = i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              key: ValueKey(isSelected),
                              size: 24,
                              color: isSelected ? settings.themeColor : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              color: isSelected ? settings.themeColor : AppColors.textMuted,
                            ),
                            child: Text(item.label),
                          ),
                          const SizedBox(height: 2),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isSelected ? 20 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                              color: settings.themeColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
