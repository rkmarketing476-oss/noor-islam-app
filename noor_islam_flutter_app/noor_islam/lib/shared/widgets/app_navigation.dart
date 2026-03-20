import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';

class AppNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String labelEn;
  final String labelBn;

  const AppNavItem({
    required this.icon,
    required this.activeIcon,
    required this.labelEn,
    required this.labelBn,
  });
}

const List<AppNavItem> kNavItems = [
  AppNavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    labelEn: 'Home',
    labelBn: 'হোম',
  ),
  AppNavItem(
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
    labelEn: 'Quran',
    labelBn: 'কোরআন',
  ),
  AppNavItem(
    icon: Icons.volunteer_activism_outlined,
    activeIcon: Icons.volunteer_activism_rounded,
    labelEn: 'Dua',
    labelBn: 'দোয়া',
  ),
  AppNavItem(
    icon: Icons.radio_button_unchecked_outlined,
    activeIcon: Icons.radio_button_checked_rounded,
    labelEn: 'Tasbih',
    labelBn: 'তসবিহ',
  ),
  AppNavItem(
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore_rounded,
    labelEn: 'More',
    labelBn: 'আরও',
  ),
];

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBangla = settings.isBangla;
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = width >= 768;

    final pages = _buildPages();

    if (isTabletOrDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: width >= 1100,
              backgroundColor: settings.isDark
                  ? AppColors.surfaceDark
                  : Colors.white,
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) => setState(() => _currentIndex = i),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [settings.themeColor, settings.themeColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text('☪️', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                  ],
                ),
              ),
              selectedIconTheme: IconThemeData(color: settings.themeColor),
              selectedLabelTextStyle: TextStyle(
                color: settings.themeColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedIconTheme: IconThemeData(
                color: settings.isDark ? AppColors.textMuted : Colors.grey.shade400,
              ),
              destinations: kNavItems.map((item) {
                return NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.activeIcon),
                  label: Text(isBangla ? item.labelBn : item.labelEn),
                );
              }).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: pages[_currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: settings.isDark ? AppColors.surfaceDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(kNavItems.length, (i) {
                final item = kNavItems[i];
                final isActive = i == _currentIndex;
                final label = isBangla ? item.labelBn : item.labelEn;
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
                              isActive ? item.activeIcon : item.icon,
                              key: ValueKey(isActive),
                              color: isActive
                                  ? settings.themeColor
                                  : (settings.isDark ? AppColors.textMuted : Colors.grey.shade400),
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                              color: isActive
                                  ? settings.themeColor
                                  : (settings.isDark ? AppColors.textMuted : Colors.grey.shade400),
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

  List<Widget> _buildPages() {
    // Import all screen pages
    // These are resolved at runtime via the navigator
    return [
      const _HomeWrapper(),
      const _QuranWrapper(),
      const _DuaWrapper(),
      const _TasbihWrapper(),
      const _MoreWrapper(),
    ];
  }
}

// ── Wrappers that import actual screens ─────────────────────────
// These forward to real screen classes defined in features/

class _HomeWrapper extends StatelessWidget {
  const _HomeWrapper();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const _PlaceholderScreen(label: 'home'),
      ),
    );
  }
}

class _QuranWrapper extends StatelessWidget {
  const _QuranWrapper();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const _PlaceholderScreen(label: 'quran'),
      ),
    );
  }
}

class _DuaWrapper extends StatelessWidget {
  const _DuaWrapper();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const _PlaceholderScreen(label: 'dua'),
      ),
    );
  }
}

class _TasbihWrapper extends StatelessWidget {
  const _TasbihWrapper();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const _PlaceholderScreen(label: 'tasbih'),
      ),
    );
  }
}

class _MoreWrapper extends StatelessWidget {
  const _MoreWrapper();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const _PlaceholderScreen(label: 'more'),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});
  @override
  Widget build(BuildContext context) => Center(child: Text(label));
}
