import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/glass_card.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  late AnimationController _animCtrl;
  String _query = '';
  int _activeTab = 0; // 0: Surah, 1: Juz

  final List<String> _surahTypesEn = ['Meccan', 'Medinan'];
  final List<String> _surahTypesBn = ['মক্কী', 'মাদানী'];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  List<int> get _filteredSurahs {
    if (_query.isEmpty) return List.generate(114, (i) => i + 1);
    final q = _query.toLowerCase();
    return List.generate(114, (i) => i + 1).where((s) {
      final nameEn = quran.getSurahNameEnglish(s).toLowerCase();
      final nameAr = quran.getSurahNameArabic(s);
      return nameEn.contains(q) || nameAr.contains(q) || s.toString() == q;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final theme = Theme.of(context);
    final isDark = settings.isDark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.quran, style: theme.textTheme.titleLarge),
                Text(
                  isBn ? 'পবিত্র কোরআনুল কারীম' : 'Al-Quran al-Kareem',
                  style: theme.textTheme.bodySmall?.copyWith(color: settings.themeColor),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.bookmark_outline_rounded, color: settings.themeColor),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: strings.searchSurah,
                    prefixIcon: Icon(Icons.search, color: settings.themeColor),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppColors.cardDark : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          // Surah Count badge
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: settings.themeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isBn ? '১১৪টি সূরা' : '114 Surahs',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: settings.themeColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isBn ? '৬,২৩৬টি আয়াত' : '6,236 Verses',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          // Surah List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final surahNum = _filteredSurahs[i];
                  return _SurahListTile(
                    surahNumber: surahNum,
                    settings: settings,
                    isBn: isBn,
                    theme: theme,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahDetailScreen(surahNumber: surahNum),
                      ),
                    ),
                  );
                },
                childCount: _filteredSurahs.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _SurahListTile extends StatelessWidget {
  final int surahNumber;
  final SettingsProvider settings;
  final bool isBn;
  final ThemeData theme;
  final VoidCallback onTap;

  const _SurahListTile({
    required this.surahNumber,
    required this.settings,
    required this.isBn,
    required this.theme,
    required this.onTap,
  });

  static const List<String> _revelations = [
    '', // placeholder for 1-indexed
    'Meccan','Meccan','Medinan','Medinan','Medinan','Medinan','Meccan','Medinan',
    'Medinan','Medinan','Meccan','Medinan','Medinan','Medinan','Meccan','Medinan',
    'Meccan','Medinan','Medinan','Meccan','Meccan','Medinan','Medinan','Medinan',
    'Medinan','Meccan','Meccan','Meccan','Meccan','Medinan','Medinan','Medinan',
    'Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan',
    'Medinan','Meccan','Meccan','Medinan','Medinan','Medinan','Medinan','Medinan',
    'Medinan','Meccan','Medinan','Medinan','Meccan','Medinan','Medinan','Medinan',
    'Medinan','Medinan','Meccan','Medinan','Medinan','Medinan','Meccan','Meccan',
    'Medinan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan',
    'Meccan','Meccan','Meccan','Meccan','Meccan','Medinan','Meccan','Medinan',
    'Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan',
    'Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan',
    'Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan',
    'Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Meccan','Medinan',
    'Meccan','Meccan',
  ];

  @override
  Widget build(BuildContext context) {
    final nameAr = quran.getSurahNameArabic(surahNumber);
    final nameEn = quran.getSurahNameEnglish(surahNumber);
    final verseCount = quran.getVerseCount(surahNumber);
    final isDark = settings.isDark;

    final revelation = surahNumber < _revelations.length ? _revelations[surahNumber] : '';
    final isMedian = revelation == 'Medinan';
    final revColor = isMedian ? const Color(0xFF0EA5E9) : settings.themeColor;
    final revLabel = isBn ? (isMedian ? 'মাদানী' : 'মক্কী') : revelation;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Number badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: settings.themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      surahNumber.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: settings.themeColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            nameEn,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: revColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              revLabel,
                              style: TextStyle(fontSize: 9, color: revColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBn ? '$verseCount আয়াত' : '$verseCount Verses',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                // Arabic name
                Text(
                  nameAr,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                    height: 1.4,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
