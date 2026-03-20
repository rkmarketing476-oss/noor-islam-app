import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../shared/widgets/glass_card.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  PrayerTimes? _prayerTimes;
  bool _loading = true;
  String? _error;
  String _locationName = '';
  Prayer? _nextPrayer;
  DateTime? _nextPrayerTime;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      setState(() => _loading = true);
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('location_service');

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) throw Exception('permission_denied');

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      final coordinates = Coordinates(pos.latitude, pos.longitude);
      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.hanafi;

      final now = DateComponents.from(DateTime.now());
      final pt = PrayerTimes(coordinates, now, params);

      // Determine next prayer
      final currentPrayer = pt.currentPrayer();
      final nextPr = pt.nextPrayer();
      final nextTime = pt.timeForPrayer(nextPr);

      setState(() {
        _prayerTimes = pt;
        _nextPrayer = nextPr;
        _nextPrayerTime = nextTime;
        _locationName = '${pos.latitude.toStringAsFixed(2)}°N, ${pos.longitude.toStringAsFixed(2)}°E';
        _loading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '--:--';
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final theme = Theme.of(context);
    final isDark = settings.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPrayerTimes,
          color: settings.themeColor,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.prayer, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                          Text(isBn ? 'আজকের নামাজের সময়সূচি' : 'Today\'s Prayer Schedule',
                              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _loadPrayerTimes,
                        icon: Icon(Icons.refresh_rounded, color: settings.themeColor),
                      ),
                    ],
                  ),
                ),
              ),

              if (_loading)
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: settings.themeColor)),
                )
              else if (_error != null)
                SliverFillRemaining(
                  child: _buildError(settings, isBn, theme),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Next prayer banner
                      if (_nextPrayer != null) _buildNextPrayerBanner(settings, isBn, theme),
                      const SizedBox(height: 16),

                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(_locationName, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                          const SizedBox(width: 4),
                          Text('· ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Prayer list
                      ..._buildPrayerList(settings, isBn, isDark, theme),

                      const SizedBox(height: 24),

                      // Method note
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: settings.themeColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: settings.themeColor.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 16, color: settings.themeColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isBn ? 'হিসাব পদ্ধতি: ইউনিভার্সিটি অব ইসলামিক সায়েন্সেস, করাচি' : 'Method: University of Islamic Sciences, Karachi',
                                style: theme.textTheme.bodySmall?.copyWith(color: settings.themeColor),
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
      ),
    );
  }

  Widget _buildNextPrayerBanner(SettingsProvider settings, bool isBn, ThemeData theme) {
    final prayerNames = {
      Prayer.fajr: isBn ? 'ফজর' : 'Fajr',
      Prayer.sunrise: isBn ? 'সূর্যোদয়' : 'Sunrise',
      Prayer.dhuhr: isBn ? 'যোহর' : 'Dhuhr',
      Prayer.asr: isBn ? 'আসর' : 'Asr',
      Prayer.maghrib: isBn ? 'মাগরিব' : 'Maghrib',
      Prayer.isha: isBn ? 'এশা' : 'Isha',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [settings.themeColor, settings.themeColor.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: settings.themeColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          const Text('🕌', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBn ? 'পরবর্তী নামাজ' : 'Next Prayer',
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  prayerNames[_nextPrayer] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(_nextPrayerTime),
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Text(
                isBn ? 'এখন' : 'Today',
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPrayerList(SettingsProvider settings, bool isBn, bool isDark, ThemeData theme) {
    if (_prayerTimes == null) return [];

    final prayers = [
      (Prayer.fajr, isBn ? 'ফজর' : 'Fajr', '🌙', _prayerTimes!.fajr),
      (Prayer.sunrise, isBn ? 'সূর্যোদয়' : 'Sunrise', '🌅', _prayerTimes!.sunrise),
      (Prayer.dhuhr, isBn ? 'যোহর' : 'Dhuhr', '☀️', _prayerTimes!.dhuhr),
      (Prayer.asr, isBn ? 'আসর' : 'Asr', '🌤', _prayerTimes!.asr),
      (Prayer.maghrib, isBn ? 'মাগরিব' : 'Maghrib', '🌇', _prayerTimes!.maghrib),
      (Prayer.isha, isBn ? 'এশা' : 'Isha', '⭐', _prayerTimes!.isha),
    ];

    return prayers.map((p) {
      final isNext = p.$1 == _nextPrayer;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isNext
              ? settings.themeColor.withOpacity(0.08)
              : (isDark ? AppColors.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: isNext ? Border.all(color: settings.themeColor.withOpacity(0.3)) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(p.$3, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                p.$2,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
                  color: isNext ? settings.themeColor : null,
                ),
              ),
            ),
            if (isNext)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: settings.themeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(isBn ? 'পরবর্তী' : 'Next',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            Text(
              _formatTime(p.$4),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isNext ? settings.themeColor : null,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildError(SettingsProvider settings, bool isBn, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_rounded, size: 64, color: Colors.orange.shade300),
          const SizedBox(height: 16),
          Text(
            isBn ? 'লোকেশন পাওয়া যায়নি' : 'Location unavailable',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isBn ? 'নামাজের সময় দেখতে লোকেশন অনুমতি প্রয়োজন।' : 'Location permission is needed to show prayer times.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadPrayerTimes,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(isBn ? 'আবার চেষ্টা' : 'Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: settings.themeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}
