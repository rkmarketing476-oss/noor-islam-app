import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isBn = settings.isBangla;
    final strings = isBn ? AppStrings.bn : AppStrings.en;
    final theme = Theme.of(context);
    final isDark = settings.isDark;
    final bg = isDark ? AppColors.bgDark : AppColors.bgLight;
    final card = isDark ? AppColors.cardDark : Colors.white;

    return Scaffold(
      backgroundColor: bg,
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
                    Text(strings.settings,
                        style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                    Text(isBn ? 'অ্যাপ কাস্টমাইজ করুন' : 'Customize your app',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── APPEARANCE ──────────────────────────────────────────
                  _SectionHeader(title: isBn ? 'চেহারা' : 'Appearance', color: settings.themeColor),
                  _SettingCard(isDark: isDark, card: card, children: [
                    // Dark mode
                    _ToggleRow(
                      icon: Icons.dark_mode_rounded,
                      label: isBn ? 'ডার্ক মোড' : 'Dark Mode',
                      value: settings.isDark,
                      color: settings.themeColor,
                      onChanged: (_) => settings.toggleDark(),
                    ),
                    _Divider(),
                    // Animations
                    _ToggleRow(
                      icon: Icons.animation_rounded,
                      label: isBn ? 'অ্যানিমেশন' : 'Animations',
                      value: settings.animationsEnabled,
                      color: settings.themeColor,
                      onChanged: (_) => settings.toggleAnimations(),
                    ),
                    _Divider(),
                    // Glass opacity
                    _SliderRow(
                      icon: Icons.blur_on_rounded,
                      label: isBn ? 'গ্লাস স্বচ্ছতা' : 'Glass Opacity',
                      value: settings.glassOpacity,
                      color: settings.themeColor,
                      onChanged: (v) => settings.setGlassOpacity(v),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ── THEME COLOR ─────────────────────────────────────────
                  _SectionHeader(title: isBn ? 'থিম রং' : 'Theme Color', color: settings.themeColor),
                  _SettingCard(isDark: isDark, card: card, children: [
                    _ThemeColorPicker(settings: settings, isBn: isBn),
                  ]),
                  const SizedBox(height: 20),

                  // ── LANGUAGE ────────────────────────────────────────────
                  _SectionHeader(title: isBn ? 'ভাষা' : 'Language', color: settings.themeColor),
                  _SettingCard(isDark: isDark, card: card, children: [
                    _LanguagePicker(settings: settings, isBn: isBn),
                  ]),
                  const SizedBox(height: 20),

                  // ── FONT ────────────────────────────────────────────────
                  _SectionHeader(title: isBn ? 'ফন্ট' : 'Font (UI)', color: settings.themeColor),
                  _SettingCard(isDark: isDark, card: card, children: [
                    _FontPicker(settings: settings, isBn: isBn),
                  ]),
                  const SizedBox(height: 20),

                  // ── QURAN DISPLAY ───────────────────────────────────────
                  _SectionHeader(title: isBn ? 'কুরআন প্রদর্শন' : 'Quran Display', color: settings.themeColor),
                  _SettingCard(isDark: isDark, card: card, children: [
                    _ToggleRow(
                      icon: Icons.translate_rounded,
                      label: isBn ? 'উচ্চারণ দেখান' : 'Show Transliteration',
                      value: settings.showTransliteration,
                      color: settings.themeColor,
                      onChanged: (_) => settings.toggleTransliteration(),
                    ),
                    _Divider(),
                    _ToggleRow(
                      icon: Icons.text_fields_rounded,
                      label: isBn ? 'অনুবাদ দেখান' : 'Show Translation',
                      value: settings.showTranslation,
                      color: settings.themeColor,
                      onChanged: (_) => settings.toggleTranslation(),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ── ABOUT ───────────────────────────────────────────────
                  _SectionHeader(title: isBn ? 'সম্পর্কে' : 'About', color: settings.themeColor),
                  _SettingCard(isDark: isDark, card: card, children: [
                    _InfoRow(
                      icon: Icons.mosque_rounded,
                      label: isBn ? 'অ্যাপের নাম' : 'App Name',
                      value: 'Noor Islam',
                      color: settings.themeColor,
                    ),
                    _Divider(),
                    _InfoRow(
                      icon: Icons.tag_rounded,
                      label: isBn ? 'ভার্সন' : 'Version',
                      value: '1.0.0',
                      color: settings.themeColor,
                    ),
                    _Divider(),
                    _InfoRow(
                      icon: Icons.favorite_rounded,
                      label: isBn ? 'নির্মিত' : 'Made with',
                      value: '❤️ Flutter',
                      color: settings.themeColor,
                    ),
                  ]),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: color,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final bool isDark;
  final Color card;
  final List<Widget> children;
  const _SettingCard({required this.isDark, required this.card, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 56, endIndent: 16);
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;
  const _SliderRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
              Text('${(value * 100).round()}%',
                  style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w700)),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              thumbColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              overlayColor: color.withOpacity(0.1),
            ),
            child: Slider(
              value: value,
              min: 0.05,
              max: 0.6,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
          Text(value, style: TextStyle(fontSize: 14, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ThemeColorPicker extends StatelessWidget {
  final SettingsProvider settings;
  final bool isBn;
  const _ThemeColorPicker({required this.settings, required this.isBn});

  static const List<Color> _colors = [
    Color(0xFF2E7D32), // Default green
    Color(0xFF1B5E20), // Dark green
    Color(0xFF00796B), // Teal
    Color(0xFF1565C0), // Blue
    Color(0xFF6A1B9A), // Purple
    Color(0xFFE65100), // Deep orange
    Color(0xFF880E4F), // Pink
    Color(0xFF37474F), // Blue grey
    Color(0xFF4E342E), // Brown
    Color(0xFF263238), // Dark
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isBn ? 'একটি রং বেছে নিন:' : 'Choose a color:',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _colors.map((c) {
              final isSelected = settings.themeColor.value == c.value;
              return GestureDetector(
                onTap: () => settings.setThemeColor(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 44 : 38,
                  height: isSelected ? 44 : 38,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                    boxShadow: isSelected
                        ? [BoxShadow(color: c.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  final SettingsProvider settings;
  final bool isBn;
  const _LanguagePicker({required this.settings, required this.isBn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: _LangButton(
              label: 'English',
              sublabel: 'English',
              isSelected: !isBn,
              color: settings.themeColor,
              onTap: () => settings.setLanguage('en'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _LangButton(
              label: 'বাংলা',
              sublabel: 'Bangla',
              isSelected: isBn,
              color: settings.themeColor,
              onTap: () => settings.setLanguage('bn'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  const _LangButton({
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : color,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white70 : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FontPicker extends StatelessWidget {
  final SettingsProvider settings;
  final bool isBn;
  const _FontPicker({required this.settings, required this.isBn});

  static const List<Map<String, String>> _fonts = [
    {'key': 'Lato', 'label': 'Lato', 'sample': 'Aa'},
    {'key': 'Poppins', 'label': 'Poppins', 'sample': 'Aa'},
    {'key': 'Lora', 'label': 'Lora', 'sample': 'Aa'},
    {'key': 'Hind Siliguri', 'label': 'Hind Siliguri', 'sample': 'আ'},
    {'key': 'Noto Sans Bengali', 'label': 'Noto Sans', 'sample': 'আ'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              isBn ? 'UI ফন্ট বেছে নিন (আরবি ফন্ট পরিবর্তন হয় না):' : 'UI font (Arabic font stays fixed):',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _fonts.map((f) {
              final isSelected = settings.fontFamily == f['key'];
              return GestureDetector(
                onTap: () => settings.setFontFamily(f['key']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? settings.themeColor : settings.themeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? settings.themeColor : settings.themeColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        f['sample']!,
                        style: TextStyle(
                          fontFamily: f['key'],
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : settings.themeColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        f['label']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : settings.themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
