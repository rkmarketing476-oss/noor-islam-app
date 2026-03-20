import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/tasbih_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _onTap(TasbihProvider tasbih, SettingsProvider settings) async {
    // Haptic feedback
    if (settings.animationsEnabled) {
      HapticFeedback.lightImpact();
      _bounceCtrl.forward().then((_) => _bounceCtrl.reverse());
    }
    await tasbih.increment();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final tasbih = context.watch<TasbihProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final theme = Theme.of(context);
    final isDark = settings.isDark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(strings.tasbih, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                      Text(isBn ? 'ডিজিটাল তসবিহ কাউন্টার' : 'Digital Tasbih Counter',
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                  const Spacer(),
                  // Reset button
                  GestureDetector(
                    onTap: () => _confirmReset(context, tasbih, isBn),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.refresh_rounded, color: Colors.red, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Tasbih selector
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                itemCount: kTasbihList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final item = kTasbihList[i];
                  final isActive = i == tasbih.selectedIndex;
                  return GestureDetector(
                    onTap: () => tasbih.selectTasbih(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? settings.themeColor : (isDark ? AppColors.cardDark : Colors.white),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: isActive
                            ? [BoxShadow(color: settings.themeColor.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]
                            : [],
                      ),
                      child: Text(
                        isBn ? item.nameBn : item.nameEn,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : (isDark ? AppColors.textLight : AppColors.textDark),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main counter area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Arabic name
                  Text(
                    tasbih.current.arabic,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 28,
                      color: settings.themeColor,
                      height: 1.8,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isBn ? tasbih.current.nameBn : tasbih.current.nameEn,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Progress ring + counter button
                  GestureDetector(
                    onTap: () => _onTap(tasbih, settings),
                    child: AnimatedBuilder(
                      animation: _scaleAnim,
                      builder: (_, child) => Transform.scale(
                        scale: _scaleAnim.value,
                        child: child,
                      ),
                      child: SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Progress ring
                            SizedBox.expand(
                              child: CustomPaint(
                                painter: _RingPainter(
                                  progress: tasbih.progress,
                                  color: settings.themeColor,
                                  isDark: isDark,
                                ),
                              ),
                            ),
                            // Inner circle
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    settings.themeColor.withOpacity(0.15),
                                    settings.themeColor.withOpacity(0.05),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: settings.themeColor.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tasbih.count.toString(),
                                    style: TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.w900,
                                      color: settings.themeColor,
                                      height: 1.0,
                                    ),
                                  ),
                                  Text(
                                    '/ ${tasbih.target}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isBn ? 'ট্যাপ করুন' : 'Tap',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Stats row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: [
                        _StatBox(
                          label: isBn ? 'রাউন্ড' : 'Rounds',
                          value: tasbih.roundsCompleted.toString(),
                          color: AppColors.accentGold,
                          theme: theme,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _StatBox(
                          label: isBn ? 'মোট' : 'Total',
                          value: tasbih.totalCount.toString(),
                          color: settings.themeColor,
                          theme: theme,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _StatBox(
                          label: isBn ? 'লক্ষ্য' : 'Target',
                          value: tasbih.target.toString(),
                          color: const Color(0xFF8B5CF6),
                          theme: theme,
                          isDark: isDark,
                          onTap: () => _showTargetDialog(context, tasbih, isBn),
                        ),
                      ],
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

  void _confirmReset(BuildContext context, TasbihProvider tasbih, bool isBn) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isBn ? 'রিসেট করুন?' : 'Reset?'),
        content: Text(isBn ? 'সব গণনা মুছে যাবে।' : 'All counts will be cleared.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isBn ? 'না' : 'Cancel')),
          TextButton(
            onPressed: () {
              tasbih.reset();
              Navigator.pop(context);
            },
            child: Text(isBn ? 'হ্যাঁ' : 'Reset', style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTargetDialog(BuildContext context, TasbihProvider tasbih, bool isBn) {
    final ctrl = TextEditingController(text: tasbih.target.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isBn ? 'লক্ষ্য নির্ধারণ করুন' : 'Set Target'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: isBn ? 'সংখ্যা লিখুন' : 'Enter number'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isBn ? 'বাতিল' : 'Cancel')),
          TextButton(
            onPressed: () {
              final v = int.tryParse(ctrl.text);
              if (v != null && v > 0) tasbih.setTarget(v);
              Navigator.pop(context);
            },
            child: Text(isBn ? 'সেভ করুন' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;
  final bool isDark;
  final VoidCallback? onTap;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
              if (onTap != null)
                Icon(Icons.edit_rounded, size: 10, color: color.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isDark;

  _RingPainter({required this.progress, required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    const strokeWidth = 10.0;

    // Background ring
    final bgPaint = Paint()
      ..color = color.withOpacity(isDark ? 0.15 : 0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress || old.color != color;
}
