import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/glass_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedGreg = DateTime.now();
  int _displayYear = HijriCalendar.now().hYear;
  int _displayMonth = HijriCalendar.now().hMonth;

  final List<String> _hijriMonthsEn = [
    'Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
    "Jumada al-Awwal", "Jumada al-Thani", 'Rajab', "Sha'ban",
    'Ramadan', 'Shawwal', "Dhul Qa'dah", "Dhul Hijjah",
  ];

  final List<String> _hijriMonthsBn = [
    'মুহররম', 'সফর', 'রবিউল আউয়াল', 'রবিউস সানি',
    'জুমাদাল উলা', 'জুমাদাল উখরা', 'রজব', 'শাবান',
    'রমজান', 'শাওয়াল', 'জিলকদ', 'জিলহজ',
  ];

  final List<String> _islamicEvents = [
    '', // 1 - Muharram
    '1 Muharram - Islamic New Year',
    '10 Muharram - Day of Ashura',
    '', // 2 - Safar
    '', // 3 - Rabi al-Awwal
    '12 Rabi al-Awwal - Mawlid al-Nabi (Prophet\'s Birthday)',
    '', // 4 - Rabi al-Thani
    '', // 5 - Jumada al-Awwal
    '', // 6 - Jumada al-Thani
    '', // 7 - Rajab
    '27 Rajab - Isra and Mi\'raj',
    '', // 8 - Sha\'ban
    '15 Sha\'ban - Laylat al-Bara\'at',
    '', // 9 - Ramadan
    'Ramadan - Month of Fasting',
    '27 Ramadan - Laylat al-Qadr',
    '', // 10 - Shawwal
    '1 Shawwal - Eid al-Fitr',
    '', // 11 - Dhul Qa\'dah
    '', // 12 - Dhul Hijjah
    '9 Dhul Hijjah - Day of Arafat',
    '10 Dhul Hijjah - Eid al-Adha',
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final theme = Theme.of(context);
    final isDark = settings.isDark;

    final todayHijri = HijriCalendar.now();
    final todayGreg = DateTime.now();

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
                    Text(strings.calendar, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                    Text(isBn ? 'ইসলামিক হিজরি ক্যালেন্ডার' : 'Islamic Hijri Calendar',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Today banner
                  _buildTodayBanner(todayHijri, todayGreg, isBn, settings, theme),
                  const SizedBox(height: 20),

                  // Hijri month navigator
                  _buildMonthNavigator(isBn, settings, theme, isDark),
                  const SizedBox(height: 16),

                  // Calendar grid
                  _buildCalendarGrid(isBn, settings, theme, isDark),
                  const SizedBox(height: 24),

                  // Islamic events
                  _buildIslamicEvents(isBn, settings, theme, isDark),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayBanner(HijriCalendar h, DateTime g, bool isBn, SettingsProvider settings, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [settings.themeColor, settings.themeColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: settings.themeColor.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const Text('📅', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBn ? 'আজকের তারিখ' : 'Today\'s Date',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Text(
                  '${h.hDay} ${isBn ? _hijriMonthsBn[h.hMonth - 1] : h.longMonthName}, ${h.hYear} AH',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(g),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator(bool isBn, SettingsProvider settings, ThemeData theme, bool isDark) {
    final monthName = isBn ? _hijriMonthsBn[_displayMonth - 1] : _hijriMonthsEn[_displayMonth - 1];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _displayMonth--;
              if (_displayMonth < 1) { _displayMonth = 12; _displayYear--; }
            });
          },
          icon: Icon(Icons.chevron_left_rounded, color: settings.themeColor),
        ),
        Column(
          children: [
            Text(
              '$monthName $_displayYear AH',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _displayMonth++;
              if (_displayMonth > 12) { _displayMonth = 1; _displayYear++; }
            });
          },
          icon: Icon(Icons.chevron_right_rounded, color: settings.themeColor),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(bool isBn, SettingsProvider settings, ThemeData theme, bool isDark) {
    final dayLabels = isBn
        ? ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    final today = HijriCalendar.now();

    // Get first day of Hijri month
    final firstDay = HijriCalendar()
      ..hYear = _displayYear
      ..hMonth = _displayMonth
      ..hDay = 1;
    final firstGreg = firstDay.hijriToGregorian(_displayYear, _displayMonth, 1);
    final firstWeekday = firstGreg.weekday % 7; // Sunday=0

    // Days in month (28 or 29 or 30)
    final daysInMonth = _getDaysInHijriMonth(_displayYear, _displayMonth);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), blurRadius: 8)],
      ),
      child: Column(
        children: [
          // Day headers
          Row(
            children: dayLabels.map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: d == (isBn ? 'শুক্র' : 'Fri') ? settings.themeColor : AppColors.textMuted,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar cells
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.1,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (_, i) {
              if (i < firstWeekday) return const SizedBox.shrink();
              final day = i - firstWeekday + 1;
              final isToday = day == today.hDay && _displayMonth == today.hMonth && _displayYear == today.hYear;
              final isFriday = (firstWeekday + day - 1) % 7 == 5;

              return GestureDetector(
                onTap: () => setState(() => _selectedGreg = firstDay.hijriToGregorian(_displayYear, _displayMonth, day)),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday ? settings.themeColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday ? null : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                        color: isToday
                            ? Colors.white
                            : isFriday
                                ? settings.themeColor
                                : (isDark ? AppColors.textLight : AppColors.textDark),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _getDaysInHijriMonth(int year, int month) {
    // Alternate 30 and 29 day months; leap year adjustments
    if (month % 2 == 1 || (month == 12 && _isHijriLeapYear(year))) return 30;
    return 29;
  }

  bool _isHijriLeapYear(int year) {
    return [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29].contains(year % 30);
  }

  Widget _buildIslamicEvents(bool isBn, SettingsProvider settings, ThemeData theme, bool isDark) {
    final events = [
      _IslamicEvent(month: 1, day: 1, nameEn: 'Islamic New Year', nameBn: 'ইসলামি নববর্ষ', emoji: '🌙'),
      _IslamicEvent(month: 1, day: 10, nameEn: 'Day of Ashura', nameBn: 'আশুরার দিন', emoji: '🕌'),
      _IslamicEvent(month: 3, day: 12, nameEn: "Prophet's Birthday (Mawlid)", nameBn: 'ঈদে মিলাদুন্নবী', emoji: '⭐'),
      _IslamicEvent(month: 7, day: 27, nameEn: "Isra' and Mi'raj", nameBn: 'লাইলাতুল মিরাজ', emoji: '🚀'),
      _IslamicEvent(month: 8, day: 15, nameEn: "Laylat al-Bara'at", nameBn: 'শবে বরাত', emoji: '✨'),
      _IslamicEvent(month: 9, day: 1, nameEn: 'Start of Ramadan', nameBn: 'রমজান শুরু', emoji: '🌙'),
      _IslamicEvent(month: 9, day: 27, nameEn: 'Laylat al-Qadr', nameBn: 'শবে কদর', emoji: '💫'),
      _IslamicEvent(month: 10, day: 1, nameEn: 'Eid al-Fitr', nameBn: 'ঈদুল ফিতর', emoji: '🎉'),
      _IslamicEvent(month: 12, day: 9, nameEn: 'Day of Arafat', nameBn: 'আরাফাতের দিন', emoji: '🕋'),
      _IslamicEvent(month: 12, day: 10, nameEn: 'Eid al-Adha', nameBn: 'ঈদুল আযহা', emoji: '🐑'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isBn ? 'ইসলামিক উৎসব ও দিবস' : 'Islamic Events & Occasions',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...events.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(e.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isBn ? e.nameBn : e.nameEn, style: theme.textTheme.titleSmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: settings.themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isBn ? _hijriMonthsBn[e.month - 1] : _hijriMonthsEn[e.month - 1]} ${e.day}',
                  style: TextStyle(fontSize: 11, color: settings.themeColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class _IslamicEvent {
  final int month;
  final int day;
  final String nameEn;
  final String nameBn;
  final String emoji;
  const _IslamicEvent({required this.month, required this.day, required this.nameEn, required this.nameBn, required this.emoji});
}
