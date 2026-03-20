import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihItem {
  final String nameEn;
  final String nameBn;
  final String arabic;
  final int defaultTarget;

  const TasbihItem({
    required this.nameEn,
    required this.nameBn,
    required this.arabic,
    required this.defaultTarget,
  });
}

const List<TasbihItem> kTasbihList = [
  TasbihItem(
    nameEn: 'Subhan Allah',
    nameBn: 'সুবহানআল্লাহ',
    arabic: 'سُبْحَانَ اللَّهِ',
    defaultTarget: 33,
  ),
  TasbihItem(
    nameEn: 'Alhamdulillah',
    nameBn: 'আলহামদুলিল্লাহ',
    arabic: 'الْحَمْدُ لِلَّهِ',
    defaultTarget: 33,
  ),
  TasbihItem(
    nameEn: 'Allahu Akbar',
    nameBn: 'আল্লাহু আকবার',
    arabic: 'اللَّهُ أَكْبَرُ',
    defaultTarget: 34,
  ),
  TasbihItem(
    nameEn: 'La Ilaha Illallah',
    nameBn: 'লা ইলাহা ইল্লাল্লাহ',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    defaultTarget: 100,
  ),
  TasbihItem(
    nameEn: 'Astaghfirullah',
    nameBn: 'আস্তাগফিরুল্লাহ',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    defaultTarget: 100,
  ),
  TasbihItem(
    nameEn: 'Durood Ibrahimi',
    nameBn: 'দুরূদ ইবরাহিমী',
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    defaultTarget: 100,
  ),
];

class TasbihProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  int _selectedIndex = 0;
  int _count = 0;
  int _totalCount = 0;
  int _target = 33;
  int _roundsCompleted = 0;

  TasbihProvider(this._prefs) {
    _load();
  }

  int get selectedIndex => _selectedIndex;
  int get count => _count;
  int get totalCount => _totalCount;
  int get target => _target;
  int get roundsCompleted => _roundsCompleted;
  TasbihItem get current => kTasbihList[_selectedIndex];
  double get progress => target > 0 ? (_count / target).clamp(0.0, 1.0) : 0;

  void _load() {
    _selectedIndex = _prefs.getInt('tasbih_index') ?? 0;
    _count = _prefs.getInt('tasbih_count') ?? 0;
    _totalCount = _prefs.getInt('tasbih_total') ?? 0;
    _roundsCompleted = _prefs.getInt('tasbih_rounds') ?? 0;
    _target = _prefs.getInt('tasbih_target') ?? kTasbihList[_selectedIndex].defaultTarget;
  }

  Future<void> increment() async {
    _count++;
    _totalCount++;
    if (_count >= _target) {
      _roundsCompleted++;
      _count = 0;
      await _prefs.setInt('tasbih_rounds', _roundsCompleted);
    }
    await _prefs.setInt('tasbih_count', _count);
    await _prefs.setInt('tasbih_total', _totalCount);
    notifyListeners();
  }

  Future<void> reset() async {
    _count = 0;
    _totalCount = 0;
    _roundsCompleted = 0;
    await _prefs.setInt('tasbih_count', 0);
    await _prefs.setInt('tasbih_total', 0);
    await _prefs.setInt('tasbih_rounds', 0);
    notifyListeners();
  }

  Future<void> selectTasbih(int index) async {
    _selectedIndex = index;
    _count = 0;
    _roundsCompleted = 0;
    _target = kTasbihList[index].defaultTarget;
    await _prefs.setInt('tasbih_index', index);
    await _prefs.setInt('tasbih_target', _target);
    await _prefs.setInt('tasbih_count', 0);
    await _prefs.setInt('tasbih_rounds', 0);
    notifyListeners();
  }

  Future<void> setTarget(int t) async {
    _target = t;
    await _prefs.setInt('tasbih_target', t);
    notifyListeners();
  }
}
