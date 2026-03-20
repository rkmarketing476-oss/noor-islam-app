import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/glass_card.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  double _fontSize = 28.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDark;
    final theme = Theme.of(context);
    final isBn = settings.isBangla;

    final surahNum = widget.surahNumber;
    final nameAr = quran.getSurahNameArabic(surahNum);
    final nameEn = quran.getSurahNameEnglish(surahNum);
    final verseCount = quran.getVerseCount(surahNum);
    final hasBismillah = surahNum != 1 && surahNum != 9;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Font size control
              IconButton(
                icon: const Icon(Icons.text_decrease_rounded),
                onPressed: () => setState(() => _fontSize = (_fontSize - 2).clamp(18.0, 40.0)),
              ),
              IconButton(
                icon: const Icon(Icons.text_increase_rounded),
                onPressed: () => setState(() => _fontSize = (_fontSize + 2).clamp(18.0, 40.0)),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      settings.themeColor,
                      settings.themeColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        nameAr,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 36,
                          color: Colors.white,
                          height: 1.6,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        'Surah $nameEn',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isBn ? '$verseCount আয়াত' : '$verseCount Verses',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bismillah
          if (hasBismillah)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      settings.themeColor.withOpacity(0.08),
                      settings.themeColor.withOpacity(0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: settings.themeColor.withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 26,
                      color: settings.themeColor,
                      height: 1.8,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // Verses
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final verseNum = i + 1;
                  return _VerseCard(
                    surahNumber: surahNum,
                    verseNumber: verseNum,
                    settings: settings,
                    theme: theme,
                    isBn: isBn,
                    arabicFontSize: _fontSize,
                  );
                },
                childCount: verseCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final int surahNumber;
  final int verseNumber;
  final SettingsProvider settings;
  final ThemeData theme;
  final bool isBn;
  final double arabicFontSize;

  const _VerseCard({
    required this.surahNumber,
    required this.verseNumber,
    required this.settings,
    required this.theme,
    required this.isBn,
    required this.arabicFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = settings.isDark;
    String arabicText;
    String translation;
    String transliteration;

    try {
      arabicText = quran.getVerse(surahNumber, verseNumber, verseEndSymbol: true);
    } catch (_) {
      arabicText = '';
    }

    try {
      translation = quran.getVerseTranslation(surahNumber, verseNumber);
    } catch (_) {
      translation = '';
    }

    try {
      transliteration = quran.getVerseTransliteration(surahNumber, verseNumber);
    } catch (_) {
      transliteration = '';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Verse header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: settings.themeColor.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                // Number
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: settings.themeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      verseNumber.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isBn ? '$surahNumber:$verseNumber নং আয়াত' : 'Verse $surahNumber:$verseNumber',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: settings.themeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Copy button
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: arabicText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isBn ? 'আয়াত কপি হয়েছে' : 'Verse copied'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Icon(Icons.copy_rounded, size: 16, color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          // Arabic text
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              arabicText,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: arabicFontSize,
                height: 2.0,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ),

          // Divider
          if (settings.showTransliteration && transliteration.isNotEmpty ||
              settings.showTranslation && translation.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: isDark ? Colors.white10 : Colors.black08,
                height: 1,
              ),
            ),

          // Transliteration
          if (settings.showTransliteration && transliteration.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Text(
                transliteration,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: settings.themeColor.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),

          // Translation
          if (settings.showTranslation && translation.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                settings.showTransliteration ? 4 : 10,
                16,
                16,
              ),
              child: Text(
                translation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textLight.withOpacity(0.85) : AppColors.textDark.withOpacity(0.75),
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
