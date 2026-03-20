import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../prayer/prayer_screen.dart';
import '../qibla/qibla_screen.dart';
import '../calendar/calendar_screen.dart';
import '../settings/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final theme = Theme.of(context);
    final isDark = settings.isDark;

    final features = [
      _FeatureItem(
        emoji: '🕌',
        titleEn: 'Prayer Times',
        titleBn: 'নামাজের সময়',
        subtitleEn: 'Daily Salah schedule',
        subtitleBn: 'দৈনিক সালাহ সময়সূচি',
        screen: const PrayerScreen(),
        gradient: [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
      ),
      _FeatureItem(
        emoji: '🧭',
        titleEn: 'Qibla Compass',
        titleBn: 'কিবলা কম্পাস',
        subtitleEn: 'Find Makkah direction',
        subtitleBn: 'মক্কার দিক খুঁজুন',
        screen: const QiblaScreen(),
        gradient: [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
      ),
      _FeatureItem(
        emoji: '📅',
        titleEn: 'Islamic Calendar',
        titleBn: 'ইসলামিক ক্যালেন্ডার',
        subtitleEn: 'Hijri dates & events',
        subtitleBn: 'হিজরি তারিখ ও উৎসব',
        screen: const CalendarScreen(),
        gradient: [const Color(0xFF00796B), const Color(0xFF4DB6AC)],
      ),
      _FeatureItem(
        emoji: '⚙️',
        titleEn: 'Settings',
        titleBn: 'সেটিংস',
        subtitleEn: 'Customize your app',
        subtitleBn: 'অ্যাপ কাস্টমাইজ করুন',
        screen: const SettingsScreen(),
        gradient: [const Color(0xFF37474F), const Color(0xFF78909C)],
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBn ? 'আরও' : 'More',
                      style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      isBn ? 'সমস্ত ইসলামিক টুলস' : 'All Islamic tools',
                      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ...features.map((f) => _FeatureCard(
                    item: f,
                    isBn: isBn,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => f.screen),
                    ),
                  )),
                  const SizedBox(height: 24),

                  // App info footer
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [settings.themeColor, settings.themeColor.withOpacity(0.7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: settings.themeColor.withOpacity(0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('☪️', style: TextStyle(fontSize: 28)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Noor Islam',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          isBn ? 'আপনার ইসলামিক সঙ্গী' : 'Your Islamic Companion',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'v1.0.0',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: settings.themeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final String emoji;
  final String titleEn;
  final String titleBn;
  final String subtitleEn;
  final String subtitleBn;
  final Widget screen;
  final List<Color> gradient;
  const _FeatureItem({
    required this.emoji,
    required this.titleEn,
    required this.titleBn,
    required this.subtitleEn,
    required this.subtitleBn,
    required this.screen,
    required this.gradient,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;
  final bool isBn;
  final bool isDark;
  final VoidCallback onTap;
  const _FeatureCard({
    required this.item,
    required this.isBn,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.18 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: item.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBn ? item.titleBn : item.titleEn,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isBn ? item.subtitleBn : item.subtitleEn,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
