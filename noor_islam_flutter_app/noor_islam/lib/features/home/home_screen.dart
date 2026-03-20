import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Timer _timer;
  late DateTime _now;
  late AnimationController _celestialController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _celestialController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _celestialController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  bool get _isNight {
    final h = _now.hour;
    return h < 5 || h >= 20;
  }

  bool get _isDusk {
    final h = _now.hour;
    return (h >= 17 && h < 20) || (h >= 5 && h < 7);
  }

  List<Color> get _skyColors {
    if (_isNight) return AppColors.skyNightGradient;
    if (_isDusk) return AppColors.skyDuskGradient;
    return AppColors.skyDayGradient;
  }

  String _getGreeting(bool isBn) {
    final h = _now.hour;
    if (isBn) {
      if (h < 12) return 'শুভ সকাল';
      if (h < 17) return 'শুভ দুপুর';
      if (h < 20) return 'শুভ সন্ধ্যা';
      return 'শুভ রাত';
    } else {
      if (h < 12) return 'Good Morning';
      if (h < 17) return 'Good Afternoon';
      if (h < 20) return 'Good Evening';
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Hijri date
    final hijri = HijriCalendar.now();
    final hijriStr = '${hijri.hDay} ${hijri.longMonthName}, ${hijri.hYear} AH';
    final gregStr = DateFormat('EEEE, MMM d, yyyy').format(_now);

    // Clock
    final hour = DateFormat('hh').format(_now);
    final minute = DateFormat('mm').format(_now);
    final second = DateFormat('ss').format(_now);
    final amPm = DateFormat('a').format(_now);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: settings.isDark
                ? [AppColors.bgDark, AppColors.bgDark.withOpacity(0.9)]
                : [AppColors.bgLight, Colors.white],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeroSection(strings, isBn, size, settings, hijriStr, gregStr, hour, minute, amPm, theme)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: _buildQuickGrid(strings, settings, theme)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverToBoxAdapter(child: _buildDailySection(strings, settings, theme)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(AppStrings strings, bool isBn, Size size, SettingsProvider settings, String hijriStr, String gregStr, String hour, String minute, String amPm, ThemeData theme) {
    return Container(
      height: 280,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 28,
        child: Stack(
          children: [
            // Sky gradient
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(seconds: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _skyColors,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
            // Stars / clouds
            if (_isNight) ..._buildStars(),
            // Celestial body
            AnimatedBuilder(
              animation: _celestialController,
              builder: (_, __) {
                final t = _celestialController.value;
                final x = 40.0 + t * (MediaQuery.of(context).size.width - 130);
                final y = _isNight
                    ? 30.0 + math.sin(t * math.pi) * 20
                    : 20.0 + math.sin(t * math.pi) * 40;
                return Positioned(
                  left: x,
                  top: y,
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 2),
                    child: _isNight
                        ? _MoonWidget(key: const ValueKey('moon'))
                        : _SunWidget(key: const ValueKey('sun'), isDusk: _isDusk),
                  ),
                );
              },
            ),
            // Content overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(_isNight ? 0.55 : 0.35),
                    ],
                  ),
                ),
              ),
            ),
            // Text content
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.salaam,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$hour:$minute',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          amPm,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        hijriStr,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    gregStr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStars() {
    final rng = math.Random(42);
    return List.generate(20, (i) {
      return Positioned(
        left: rng.nextDouble() * 320,
        top: rng.nextDouble() * 120,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (_, __) {
            final opacity = 0.4 + _pulseController.value * 0.6;
            return Container(
              width: rng.nextDouble() * 3 + 1,
              height: rng.nextDouble() * 3 + 1,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildQuickGrid(AppStrings strings, SettingsProvider settings, ThemeData theme) {
    final items = [
      _QuickItem(emoji: '📖', labelEn: 'Quran', labelBn: 'কোরআন', color: AppColors.primaryGreen, navIndex: 1),
      _QuickItem(emoji: '🤲', labelEn: 'Dua', labelBn: 'দোয়া', color: const Color(0xFF8B5CF6), navIndex: 2),
      _QuickItem(emoji: '📿', labelEn: 'Tasbih', labelBn: 'তসবিহ', color: const Color(0xFFD97706), navIndex: 3),
      _QuickItem(emoji: '🧭', labelEn: 'Qibla', labelBn: 'কিবলা', color: const Color(0xFF0EA5E9), navIndex: 4),
      _QuickItem(emoji: '🕌', labelEn: 'Prayer', labelBn: 'নামাজ', color: const Color(0xFFEC4899), navIndex: 4),
      _QuickItem(emoji: '📅', labelEn: 'Calendar', labelBn: 'ক্যালেন্ডার', color: const Color(0xFF10B981), navIndex: 4),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.isBangla ? 'ইসলামিক টুলস' : 'Islamic Tools',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            return AppCard(
              padding: EdgeInsets.zero,
              onTap: () => widget.onNavigate?.call(item.navIndex),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      item.color.withOpacity(0.15),
                      item.color.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 6),
                    Text(
                      settings.isBangla ? item.labelBn : item.labelEn,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: item.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDailySection(AppStrings strings, SettingsProvider settings, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.isBangla ? 'দৈনিক জিকির' : 'Daily Dhikr',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _buildDhikrCard(
          arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          transliteration: "Subhānallāhi wa bihamdih",
          meaningEn: 'Glory be to Allah and all praise is due to Him.',
          meaningBn: 'আল্লাহর পবিত্রতা ঘোষণা করি এবং তাঁর প্রশংসা করি।',
          count: '100×',
          settings: settings,
          theme: theme,
          color: settings.themeColor,
        ),
        const SizedBox(height: 10),
        _buildDhikrCard(
          arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
          transliteration: "Allāhumma salli \'alā Muhammadin",
          meaningEn: 'O Allah, send blessings upon Muhammad.',
          meaningBn: 'হে আল্লাহ! মুহাম্মাদের উপর দরূদ পাঠাও।',
          count: '10×',
          settings: settings,
          theme: theme,
          color: AppColors.accentGold,
        ),
      ],
    );
  }

  Widget _buildDhikrCard({
    required String arabic,
    required String transliteration,
    required String meaningEn,
    required String meaningBn,
    required String count,
    required SettingsProvider settings,
    required ThemeData theme,
    required Color color,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(count, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arabic,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    color: settings.isDark ? AppColors.textLight : AppColors.textDark,
                    height: 1.6,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  transliteration,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  settings.isBangla ? meaningBn : meaningEn,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickItem {
  final String emoji;
  final String labelEn;
  final String labelBn;
  final Color color;
  final int navIndex;
  const _QuickItem({required this.emoji, required this.labelEn, required this.labelBn, required this.color, required this.navIndex});
}

class _SunWidget extends StatelessWidget {
  final bool isDusk;
  const _SunWidget({super.key, required this.isDusk});
  @override
  Widget build(BuildContext context) {
    final color = isDusk ? const Color(0xFFFF7043) : const Color(0xFFFFC107);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.6), blurRadius: 20, spreadRadius: 5),
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 40, spreadRadius: 10),
        ],
      ),
    );
  }
}

class _MoonWidget extends StatelessWidget {
  const _MoonWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF5F0DC),
        boxShadow: [
          BoxShadow(color: const Color(0xFFF5F0DC).withOpacity(0.5), blurRadius: 16, spreadRadius: 3),
        ],
      ),
      child: const Center(
        child: Text('🌙', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
