import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with TickerProviderStateMixin {
  late AnimationController _needleCtrl;
  double _currentNeedle = 0;
  LocationPermission _permission = LocationPermission.denied;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _needleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _init();
  }

  @override
  void dispose() {
    _needleCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() { _error = 'location_service'; _loading = false; });
        return;
      }
      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
      }
      if (_permission == LocationPermission.deniedForever) {
        setState(() { _error = 'permission_denied'; _loading = false; });
        return;
      }
      setState(() => _loading = false);
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(strings.qibla, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                      Text(isBn ? 'কাবার দিক নির্ণয়' : 'Find direction to Makkah',
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: _loading
                  ? _buildLoading(settings, isBn)
                  : _error != null
                      ? _buildError(settings, isBn, theme)
                      : _buildCompass(settings, isBn, theme, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(SettingsProvider settings, bool isBn) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: settings.themeColor),
          const SizedBox(height: 16),
          Text(isBn ? 'লোকেশন খুঁজছি...' : 'Finding location...'),
        ],
      ),
    );
  }

  Widget _buildError(SettingsProvider settings, bool isBn, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off_rounded, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              _error == 'location_service'
                  ? (isBn ? 'লোকেশন সার্ভিস বন্ধ আছে' : 'Location service is disabled')
                  : (isBn ? 'লোকেশন অনুমতি নেই' : 'Location permission denied'),
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isBn ? 'কিবলা কম্পাস ব্যবহার করতে লোকেশন অনুমতি প্রয়োজন।' : 'Location permission is required to use the Qibla compass.',
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                setState(() => _loading = true);
                await _init();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(isBn ? 'আবার চেষ্টা করুন' : 'Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: settings.themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass(SettingsProvider settings, bool isBn, ThemeData theme, bool isDark) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: settings.themeColor));
        }

        final qd = snapshot.data!;
        final qiblaAngle = qd.qiblah; // degrees
        final deviceAngle = qd.direction;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Info cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _InfoCard(
                    icon: Icons.explore_rounded,
                    label: isBn ? 'ডিভাইসের দিক' : 'Device',
                    value: '${deviceAngle.toStringAsFixed(1)}°',
                    color: AppColors.accentGold,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _InfoCard(
                    icon: Icons.mosque_rounded,
                    label: isBn ? 'কিবলার দিক' : 'Qibla',
                    value: '${qiblaAngle.toStringAsFixed(1)}°',
                    color: settings.themeColor,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Compass
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            isDark ? AppColors.cardDark : Colors.white,
                            isDark ? AppColors.surfaceDark : AppColors.bgLight,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Compass rose
                    Transform.rotate(
                      angle: -qd.direction * (math.pi / 180),
                      child: _CompassRose(isDark: isDark, color: settings.themeColor),
                    ),
                    // Qibla needle
                    Transform.rotate(
                      angle: (qd.qiblah - qd.direction) * (math.pi / 180),
                      child: _QiblaNeedle(color: settings.themeColor),
                    ),
                    // Center dot
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: settings.themeColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(color: settings.themeColor.withOpacity(0.4), blurRadius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Direction badge
            _DirectionBadge(
              qd: qd,
              isBn: isBn,
              color: settings.themeColor,
              theme: theme,
              isDark: isDark,
            ),

            const SizedBox(height: 16),
            Text(
              isBn ? 'সবুজ তীরটি কাবার দিক নির্দেশ করে' : 'Green arrow points toward the Kaaba',
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
          ],
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _CompassRose extends StatelessWidget {
  final bool isDark;
  final Color color;
  const _CompassRose({required this.isDark, required this.color});

  @override
  Widget build(BuildContext context) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    const angles = [0, 45, 90, 135, 180, 225, 270, 315];

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Tick marks
          CustomPaint(
            size: const Size(280, 280),
            painter: _TickPainter(isDark: isDark, primaryColor: color),
          ),
          // Cardinal labels
          ...List.generate(dirs.length, (i) {
            final angle = angles[i] * math.pi / 180;
            final radius = 110.0;
            final x = radius * math.sin(angle);
            final y = -radius * math.cos(angle);
            final isCardinal = i % 2 == 0;
            return Positioned(
              left: 140 + x - 12,
              top: 140 + y - 12,
              child: SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: Text(
                    dirs[i],
                    style: TextStyle(
                      fontSize: isCardinal ? 13 : 9,
                      fontWeight: isCardinal ? FontWeight.w800 : FontWeight.w500,
                      color: dirs[i] == 'N'
                          ? Colors.red
                          : (isDark ? AppColors.textLight : AppColors.textDark),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  final bool isDark;
  final Color primaryColor;
  const _TickPainter({required this.isDark, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = 130.0;

    for (int i = 0; i < 72; i++) {
      final angle = i * 5 * math.pi / 180;
      final isMain = i % 18 == 0;
      final isSub = i % 9 == 0;
      final length = isMain ? 14.0 : (isSub ? 10.0 : 6.0);

      final paint = Paint()
        ..color = isMain
            ? (isDark ? AppColors.textLight : AppColors.textDark)
            : (isDark ? Colors.white30 : Colors.black26)
        ..strokeWidth = isMain ? 2 : 1
        ..strokeCap = StrokeCap.round;

      final start = Offset(center.dx + (outerR - length) * math.sin(angle), center.dy - (outerR - length) * math.cos(angle));
      final end = Offset(center.dx + outerR * math.sin(angle), center.dy - outerR * math.cos(angle));
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _QiblaNeedle extends StatelessWidget {
  final Color color;
  const _QiblaNeedle({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _NeedlePainter(color: color),
      ),
    );
  }
}

class _NeedlePainter extends CustomPainter {
  final Color color;
  const _NeedlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw arrow toward Qibla
    final paint = Paint()..color = color..strokeWidth = 3..strokeCap = StrokeCap.round;

    // Line
    canvas.drawLine(
      Offset(center.dx, center.dy + 40),
      Offset(center.dx, center.dy - 100),
      paint,
    );

    // Arrowhead
    final path = Path()
      ..moveTo(center.dx, center.dy - 110)
      ..lineTo(center.dx - 10, center.dy - 90)
      ..lineTo(center.dx + 10, center.dy - 90)
      ..close();
    canvas.drawPath(path, Paint()..color = color);

    // Kaaba emoji at tip
    final tp = TextPainter(
      text: const TextSpan(text: '🕋', style: TextStyle(fontSize: 16)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - 8, center.dy - 140));
  }

  @override
  bool shouldRepaint(_) => false;
}

class _DirectionBadge extends StatelessWidget {
  final QiblahDirection qd;
  final bool isBn;
  final Color color;
  final ThemeData theme;
  final bool isDark;

  const _DirectionBadge({
    required this.qd,
    required this.isBn,
    required this.color,
    required this.theme,
    required this.isDark,
  });

  String _cardinalDirection(double angle) {
    final dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final i = ((angle % 360 + 360) % 360 / 45).round() % 8;
    return dirs[i];
  }

  @override
  Widget build(BuildContext context) {
    final diff = (qd.qiblah - qd.direction).abs();
    final aligned = diff < 5 || diff > 355;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: aligned ? color.withOpacity(0.15) : Colors.transparent,
        border: Border.all(color: aligned ? color : Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            aligned ? Icons.check_circle_rounded : Icons.explore_rounded,
            color: aligned ? color : AppColors.textMuted,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            aligned
                ? (isBn ? '✅ কিবলামুখী!' : '✅ Facing Qibla!')
                : (isBn ? 'কিবলা: ${_cardinalDirection(qd.qiblah)} (${qd.qiblah.toStringAsFixed(0)}°)' : 'Qibla: ${_cardinalDirection(qd.qiblah)} (${qd.qiblah.toStringAsFixed(0)}°)'),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: aligned ? color : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
