// main.dart
// Vibe Alarm Pro - Flutter Android starter (single-file prototype)
// واجهة عصرية + إعدادات اهتزاز متقدمة + زر إيقاف مؤقت داخل التطبيق
//
// ملاحظات مهمة:
// - هذه نسخة واجهات ومنطق محلي أولي.
// - لا تحتوي بعد على جدولة أندرويد حقيقية في الخلفية.
// - الخطوة التالية لاحقًا: ربطها مع AlarmManager / notifications / vibration plugins.

import 'package:flutter/material.dart';

void main() {
  runApp(const VibeAlarmProApp());
}

class VibeAlarmProApp extends StatelessWidget {
  const VibeAlarmProApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6C63FF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibe Alarm Pro',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF090B14),
        cardTheme: const CardThemeData(
          color: Color(0xFF121726),
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF151B2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: seed, width: 1.4),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1A2033),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

enum AlertMode {
  vibrationOnly,
  soundOnly,
  vibrationThenSound,
  vibrationAndSound,
}

extension AlertModeLabel on AlertMode {
  String get label {
    switch (this) {
      case AlertMode.vibrationOnly:
        return 'اهتزاز فقط';
      case AlertMode.soundOnly:
        return 'رنين فقط';
      case AlertMode.vibrationThenSound:
        return 'اهتزاز ثم رنين';
      case AlertMode.vibrationAndSound:
        return 'اهتزاز + رنين';
    }
  }
}

class AlarmConfig {
  AlarmConfig({
    required this.id,
    required this.title,
    required this.time,
    required this.repeatDays,
    required this.mode,
    required this.delayBeforeStartMinutes,
    required this.vibrationDurationSeconds,
    required this.repeatEverySeconds,
    required this.totalActiveMinutes,
    required this.enableSoundAfterMinutes,
    required this.snoozeMinutes,
    required this.isEnabled,
    this.isSnoozed = false,
    this.snoozedUntil,
  });

  final String id;
  final String title;
  final TimeOfDay time;
  final List<int> repeatDays;
  final AlertMode mode;
  final int delayBeforeStartMinutes;
  final int vibrationDurationSeconds;
  final int repeatEverySeconds;
  final int totalActiveMinutes;
  final int? enableSoundAfterMinutes;
  final int snoozeMinutes;
  final bool isEnabled;
  final bool isSnoozed;
  final DateTime? snoozedUntil;

  AlarmConfig copyWith({
    String? id,
    String? title,
    TimeOfDay? time,
    List<int>? repeatDays,
    AlertMode? mode,
    int? delayBeforeStartMinutes,
    int? vibrationDurationSeconds,
    int? repeatEverySeconds,
    int? totalActiveMinutes,
    int? enableSoundAfterMinutes,
    bool clearEnableSoundAfterMinutes = false,
    int? snoozeMinutes,
    bool? isEnabled,
    bool? isSnoozed,
    DateTime? snoozedUntil,
    bool clearSnoozedUntil = false,
  }) {
    return AlarmConfig(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      repeatDays: repeatDays ?? this.repeatDays,
      mode: mode ?? this.mode,
      delayBeforeStartMinutes:
          delayBeforeStartMinutes ?? this.delayBeforeStartMinutes,
      vibrationDurationSeconds:
          vibrationDurationSeconds ?? this.vibrationDurationSeconds,
      repeatEverySeconds: repeatEverySeconds ?? this.repeatEverySeconds,
      totalActiveMinutes: totalActiveMinutes ?? this.totalActiveMinutes,
      enableSoundAfterMinutes: clearEnableSoundAfterMinutes
          ? null
          : (enableSoundAfterMinutes ?? this.enableSoundAfterMinutes),
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      isEnabled: isEnabled ?? this.isEnabled,
      isSnoozed: isSnoozed ?? this.isSnoozed,
      snoozedUntil:
          clearSnoozedUntil ? null : (snoozedUntil ?? this.snoozedUntil),
    );
  }
}

class AppSettings {
  const AppSettings({
    required this.defaultSnoozeMinutes,
    required this.defaultVibrationDurationSeconds,
    required this.defaultRepeatEverySeconds,
    required this.defaultTotalActiveMinutes,
    required this.defaultDelayBeforeStartMinutes,
    required this.fullScreenAlarm,
    required this.darkMode,
    required this.vibrationFirst,
  });

  final int defaultSnoozeMinutes;
  final int defaultVibrationDurationSeconds;
  final int defaultRepeatEverySeconds;
  final int defaultTotalActiveMinutes;
  final int defaultDelayBeforeStartMinutes;
  final bool fullScreenAlarm;
  final bool darkMode;
  final bool vibrationFirst;

  AppSettings copyWith({
    int? defaultSnoozeMinutes,
    int? defaultVibrationDurationSeconds,
    int? defaultRepeatEverySeconds,
    int? defaultTotalActiveMinutes,
    int? defaultDelayBeforeStartMinutes,
    bool? fullScreenAlarm,
    bool? darkMode,
    bool? vibrationFirst,
  }) {
    return AppSettings(
      defaultSnoozeMinutes:
          defaultSnoozeMinutes ?? this.defaultSnoozeMinutes,
      defaultVibrationDurationSeconds: defaultVibrationDurationSeconds ??
          this.defaultVibrationDurationSeconds,
      defaultRepeatEverySeconds:
          defaultRepeatEverySeconds ?? this.defaultRepeatEverySeconds,
      defaultTotalActiveMinutes:
          defaultTotalActiveMinutes ?? this.defaultTotalActiveMinutes,
      defaultDelayBeforeStartMinutes:
          defaultDelayBeforeStartMinutes ?? this.defaultDelayBeforeStartMinutes,
      fullScreenAlarm: fullScreenAlarm ?? this.fullScreenAlarm,
      darkMode: darkMode ?? this.darkMode,
      vibrationFirst: vibrationFirst ?? this.vibrationFirst,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  AppSettings settings = const AppSettings(
    defaultSnoozeMinutes: 5,
    defaultVibrationDurationSeconds: 3,
    defaultRepeatEverySeconds: 20,
    defaultTotalActiveMinutes: 10,
    defaultDelayBeforeStartMinutes: 0,
    fullScreenAlarm: true,
    darkMode: true,
    vibrationFirst: true,
  );

  final List<AlarmConfig> _alarms = [
    AlarmConfig(
      id: 'a1',
      title: 'الاستيقاظ',
      time: const TimeOfDay(hour: 6, minute: 30),
      repeatDays: [1, 2, 3, 4, 5],
      mode: AlertMode.vibrationOnly,
      delayBeforeStartMinutes: 0,
      vibrationDurationSeconds: 3,
      repeatEverySeconds: 20,
      totalActiveMinutes: 10,
      enableSoundAfterMinutes: null,
      snoozeMinutes: 5,
      isEnabled: true,
    ),
    AlarmConfig(
      id: 'a2',
      title: 'تذكير مهم',
      time: const TimeOfDay(hour: 12, minute: 15),
      repeatDays: [0, 1, 2, 3, 4, 5, 6],
      mode: AlertMode.vibrationThenSound,
      delayBeforeStartMinutes: 2,
      vibrationDurationSeconds: 2,
      repeatEverySeconds: 30,
      totalActiveMinutes: 12,
      enableSoundAfterMinutes: 4,
      snoozeMinutes: 4,
      isEnabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildAlarmPage(),
      SettingsScreen(
        settings: settings,
        onChanged: (value) => setState(() => settings = value),
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1020), Color(0xFF090B14), Color(0xFF121933)],
          ),
        ),
        child: SafeArea(child: pages[_currentIndex]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: const Color(0xFF0E1322),
        indicatorColor: const Color(0x336C63FF),
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.alarm_outlined),
            selectedIcon: Icon(Icons.alarm),
            label: 'المنبهات',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'الإعدادات',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              onPressed: _showCreateAlarmSheet,
              icon: const Icon(Icons.add_alarm),
              label: const Text('منبه جديد'),
            )
          : null,
    );
  }

  Widget _buildAlarmPage() {
    final activeCount = _alarms.where((e) => e.isEnabled).length;
    final vibrationOnlyCount =
        _alarms.where((e) => e.mode == AlertMode.vibrationOnly).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopHero(),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'نشط الآن',
                  value: '$activeCount',
                  icon: Icons.bolt,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'اهتزاز فقط',
                  value: '$vibrationOnlyCount',
                  icon: Icons.vibration,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'قائمة المنبهات',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _alarms.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    itemCount: _alarms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final alarm = _alarms[index];
                      return AlarmCard(
                        alarm: alarm,
                        onToggle: (value) {
                          setState(() {
                            _alarms[index] = alarm.copyWith(isEnabled: value);
                          });
                        },
                        onEdit: () => _showEditAlarmSheet(alarm, index),
                        onDelete: () {
                          setState(() => _alarms.removeAt(index));
                        },
                        onSnooze: () => _snoozeAlarm(index),
                        onPreview: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AlarmPreviewScreen(
                                alarm: alarm,
                                onSnooze: () {
                                  Navigator.pop(context);
                                  _snoozeAlarm(index);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCreateAlarmSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AlarmEditorSheet(
        initialValue: AlarmConfig(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'منبه جديد',
          time: const TimeOfDay(hour: 7, minute: 0),
          repeatDays: const [0, 1, 2, 3, 4, 5, 6],
          mode: settings.vibrationFirst
              ? AlertMode.vibrationOnly
              : AlertMode.vibrationAndSound,
          delayBeforeStartMinutes: settings.defaultDelayBeforeStartMinutes,
          vibrationDurationSeconds: settings.defaultVibrationDurationSeconds,
          repeatEverySeconds: settings.defaultRepeatEverySeconds,
          totalActiveMinutes: settings.defaultTotalActiveMinutes,
          enableSoundAfterMinutes: null,
          snoozeMinutes: settings.defaultSnoozeMinutes,
          isEnabled: true,
        ),
        onSave: (alarm) {
          setState(() => _alarms.add(alarm));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditAlarmSheet(AlarmConfig alarm, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AlarmEditorSheet(
        initialValue: alarm,
        onSave: (updated) {
          setState(() => _alarms[index] = updated);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _snoozeAlarm(int index) {
    final alarm = _alarms[index];
    final until = DateTime.now().add(Duration(minutes: alarm.snoozeMinutes));

    setState(() {
      _alarms[index] = alarm.copyWith(
        isSnoozed: true,
        snoozedUntil: until,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تأجيل "${alarm.title}" لمدة ${alarm.snoozeMinutes} دقائق',
        ),
        action: SnackBarAction(
          label: 'إلغاء',
          onPressed: () {
            setState(() {
              _alarms[index] = _alarms[index].copyWith(
                isSnoozed: false,
                clearSnoozedUntil: true,
              );
            });
          },
        ),
      ),
    );
  }
}

class AlarmCard extends StatelessWidget {
  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onSnooze,
    required this.onPreview,
  });

  final AlarmConfig alarm;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSnooze;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTime(alarm.time),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alarm.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: alarm.isEnabled,
                  onChanged: onToggle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(Icons.repeat, _daysLabel(alarm.repeatDays)),
                _chip(Icons.vibration, alarm.mode.label),
                _chip(Icons.hourglass_bottom,
                    'بعد ${alarm.delayBeforeStartMinutes} د'),
                _chip(Icons.timelapse,
                    'يهتز ${alarm.vibrationDurationSeconds} ث'),
                _chip(Icons.sync, 'كل ${alarm.repeatEverySeconds} ث'),
                _chip(Icons.schedule, 'لمدة ${alarm.totalActiveMinutes} د'),
                _chip(Icons.snooze, 'غفوة ${alarm.snoozeMinutes} د'),
                if (alarm.enableSoundAfterMinutes != null)
                  _chip(Icons.music_note,
                      'الرنين بعد ${alarm.enableSoundAfterMinutes} د'),
                if (alarm.isSnoozed && alarm.snoozedUntil != null)
                  _chip(
                    Icons.pause_circle_outline,
                    'مؤجل حتى ${_formatDateTimeShort(alarm.snoozedUntil!)}',
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: onSnooze,
                  icon: const Icon(Icons.snooze),
                  label: const Text('إيقاف مؤقت'),
                ),
                OutlinedButton.icon(
                  onPressed: onPreview,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('معاينة التنبيه'),
                ),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('تعديل'),
                ),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('حذف'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF182038),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9F99FF)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class AlarmEditorSheet extends StatefulWidget {
  const AlarmEditorSheet({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  final AlarmConfig initialValue;
  final ValueChanged<AlarmConfig> onSave;

  @override
  State<AlarmEditorSheet> createState() => _AlarmEditorSheetState();
}

class _AlarmEditorSheetState extends State<AlarmEditorSheet> {
  late final TextEditingController _titleController;
  late TimeOfDay _time;
  late List<int> _repeatDays;
  late AlertMode _mode;
  late int _delayBeforeStartMinutes;
  late int _vibrationDurationSeconds;
  late int _repeatEverySeconds;
  late int _totalActiveMinutes;
  late int _snoozeMinutes;
  int? _enableSoundAfterMinutes;

  @override
  void initState() {
    super.initState();
    final value = widget.initialValue;
    _titleController = TextEditingController(text: value.title);
    _time = value.time;
    _repeatDays = [...value.repeatDays];
    _mode = value.mode;
    _delayBeforeStartMinutes = value.delayBeforeStartMinutes;
    _vibrationDurationSeconds = value.vibrationDurationSeconds;
    _repeatEverySeconds = value.repeatEverySeconds;
    _totalActiveMinutes = value.totalActiveMinutes;
    _snoozeMinutes = value.snoozeMinutes;
    _enableSoundAfterMinutes = value.enableSoundAfterMinutes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 18, 18, bottomInset + 18),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1221),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'إضافة / تعديل منبه',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'اسم المنبه',
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 14),
            _TimeTile(
              time: _time,
              onTap: _pickTime,
            ),
            const SizedBox(height: 18),
            const Text(
              'الأيام',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final selected = _repeatDays.contains(index);
                return FilterChip(
                  selected: selected,
                  label: Text(_dayName(index)),
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        _repeatDays.remove(index);
                      } else {
                        _repeatDays.add(index);
                        _repeatDays.sort();
                      }
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<AlertMode>(
              value: _mode,
              decoration: const InputDecoration(
                labelText: 'وضع التنبيه',
                prefixIcon: Icon(Icons.notifications_active_outlined),
              ),
              items: AlertMode.values
                  .map(
                    (mode) => DropdownMenuItem(
                      value: mode,
                      child: Text(mode.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _mode = value;
                  if (_mode != AlertMode.vibrationThenSound) {
                    _enableSoundAfterMinutes = null;
                  } else {
                    _enableSoundAfterMinutes ??= 3;
                  }
                });
              },
            ),
            const SizedBox(height: 18),
            _SliderField(
              label: 'بعد كم دقيقة يبدأ؟',
              valueLabel: '$_delayBeforeStartMinutes دقيقة',
              value: _delayBeforeStartMinutes.toDouble(),
              min: 0,
              max: 30,
              divisions: 30,
              icon: Icons.hourglass_top,
              onChanged: (v) => setState(() => _delayBeforeStartMinutes = v.round()),
            ),
            _SliderField(
              label: 'مدة الاهتزاز الواحد',
              valueLabel: '$_vibrationDurationSeconds ثانية',
              value: _vibrationDurationSeconds.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              icon: Icons.vibration,
              onChanged: (v) => setState(() => _vibrationDurationSeconds = v.round()),
            ),
            _SliderField(
              label: 'كل كم ثانية يتكرر؟',
              valueLabel: '$_repeatEverySeconds ثانية',
              value: _repeatEverySeconds.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              icon: Icons.sync,
              onChanged: (v) => setState(() => _repeatEverySeconds = v.round()),
            ),
            _SliderField(
              label: 'كم دقيقة يستمر؟',
              valueLabel: '$_totalActiveMinutes دقيقة',
              value: _totalActiveMinutes.toDouble(),
              min: 1,
              max: 60,
              divisions: 59,
              icon: Icons.timelapse,
              onChanged: (v) => setState(() => _totalActiveMinutes = v.round()),
            ),
            _SliderField(
              label: 'مدة الإيقاف المؤقت',
              valueLabel: '$_snoozeMinutes دقيقة',
              value: _snoozeMinutes.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              icon: Icons.snooze,
              onChanged: (v) => setState(() => _snoozeMinutes = v.round()),
            ),
            if (_mode == AlertMode.vibrationThenSound)
              _SliderField(
                label: 'بعد كم دقيقة يتحول إلى رنين؟',
                valueLabel: '${_enableSoundAfterMinutes ?? 3} دقيقة',
                value: (_enableSoundAfterMinutes ?? 3).toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                icon: Icons.music_note_outlined,
                onChanged: (v) {
                  setState(() => _enableSoundAfterMinutes = v.round());
                },
              ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _save,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'حفظ المنبه',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color(0xFF6C63FF),
              ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _save() {
    final title = _titleController.text.trim().isEmpty
        ? 'منبه بدون اسم'
        : _titleController.text.trim();

    widget.onSave(
      widget.initialValue.copyWith(
        title: title,
        time: _time,
        repeatDays: _repeatDays,
        mode: _mode,
        delayBeforeStartMinutes: _delayBeforeStartMinutes,
        vibrationDurationSeconds: _vibrationDurationSeconds,
        repeatEverySeconds: _repeatEverySeconds,
        totalActiveMinutes: _totalActiveMinutes,
        enableSoundAfterMinutes: _enableSoundAfterMinutes,
        clearEnableSoundAfterMinutes: _mode != AlertMode.vibrationThenSound,
        snoozeMinutes: _snoozeMinutes,
        isEnabled: true,
      ),
    );
  }
}

class AlarmPreviewScreen extends StatelessWidget {
  const AlarmPreviewScreen({
    super.key,
    required this.alarm,
    required this.onSnooze,
  });

  final AlarmConfig alarm;
  final VoidCallback onSnooze;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1640), Color(0xFF090B14), Color(0xFF0C1228)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0x226C63FF),
                    border: Border.all(color: const Color(0x556C63FF), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.vibration,
                    size: 52,
                    color: Color(0xFFB5B0FF),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _formatTime(alarm.time),
                  style: const TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  alarm.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  alarm.mode.label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _previewChip('الاهتزاز ${alarm.vibrationDurationSeconds} ث'),
                    _previewChip('كل ${alarm.repeatEverySeconds} ث'),
                    _previewChip('مدة ${alarm.totalActiveMinutes} د'),
                    _previewChip('غفوة ${alarm.snoozeMinutes} د'),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(color: Color(0x556C63FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: onSnooze,
                        icon: const Icon(Icons.snooze),
                        label: const Text('إيقاف مؤقت'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text('إيقاف'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _previewChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2C),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text),
    );
  }
}

class _TopHero extends StatelessWidget {
  const _TopHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C63FF), Color(0xFF4D9BFF), Color(0xFF1ED6C1)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x336C63FF),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: const [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vibe Alarm Pro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'منبه أندرويد عصري يركز على الاهتزاز أولًا، مع تحكم كامل في التأخير والتكرار والمدة والإيقاف المؤقت.',
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0x33FFFFFF),
            child: Icon(Icons.vibration, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0x226C63FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF9F99FF)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({required this.time, required this.onTap});

  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF151B2C),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0x226C63FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.access_time, color: Color(0xFF9F99FF)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('وقت المنبه',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(time),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.icon,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final IconData icon;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF121726),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF9F99FF)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                valueLabel,
                style: const TextStyle(
                  color: Color(0xFFB8B3FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإعدادات',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'إعدادات افتراضية لتطبيق الاهتزاز والمنبه.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              children: [
                _SettingsSwitchTile(
                  title: 'ملء الشاشة عند التنبيه',
                  subtitle: 'إظهار شاشة تنبيه كبيرة وواضحة.',
                  value: settings.fullScreenAlarm,
                  onChanged: (v) => onChanged(settings.copyWith(fullScreenAlarm: v)),
                ),
                _SettingsSwitchTile(
                  title: 'الوضع الداكن',
                  subtitle: 'تصميم عصري داكن ومريح.',
                  value: settings.darkMode,
                  onChanged: (v) => onChanged(settings.copyWith(darkMode: v)),
                ),
                _SettingsSwitchTile(
                  title: 'الاهتزاز أولًا افتراضيًا',
                  subtitle: 'عند إنشاء منبه جديد يكون على اهتزاز فقط.',
                  value: settings.vibrationFirst,
                  onChanged: (v) => onChanged(settings.copyWith(vibrationFirst: v)),
                ),
                const SizedBox(height: 10),
                _NumberSettingCard(
                  title: 'الغفوة الافتراضية',
                  value: '${settings.defaultSnoozeMinutes} دقائق',
                ),
                const SizedBox(height: 10),
                _NumberSettingCard(
                  title: 'مدة الاهتزاز الافتراضية',
                  value: '${settings.defaultVibrationDurationSeconds} ثوانٍ',
                ),
                const SizedBox(height: 10),
                _NumberSettingCard(
                  title: 'التكرار الافتراضي',
                  value: 'كل ${settings.defaultRepeatEverySeconds} ثانية',
                ),
                const SizedBox(height: 10),
                _NumberSettingCard(
                  title: 'مدة نشاط التنبيه الافتراضية',
                  value: '${settings.defaultTotalActiveMinutes} دقيقة',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _NumberSettingCard extends StatelessWidget {
  const _NumberSettingCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0x226C63FF),
              child: Icon(
                Icons.settings_input_component,
                color: Color(0xFF9F99FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 36,
            backgroundColor: Color(0x226C63FF),
            child: Icon(Icons.alarm_off, size: 34, color: Color(0xFF9F99FF)),
          ),
          SizedBox(height: 14),
          Text(
            'لا توجد منبهات بعد',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text(
            'ابدأ بإضافة أول منبه مع وضع الاهتزاز فقط.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

String _formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final suffix = time.period == DayPeriod.am ? 'ص' : 'م';
  return '$hour:$minute $suffix';
}

String _daysLabel(List<int> days) {
  if (days.length == 7) return 'يوميًا';
  if (days.isEmpty) return 'مرة واحدة';
  return days.map(_dayNameShort).join(' • ');
}

String _dayName(int day) {
  const names = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];
  return names[day];
}

String _dayNameShort(int day) {
  const names = ['أحد', 'اثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت'];
  return names[day];
}

String _formatDateTimeShort(DateTime dateTime) {
  final hour24 = dateTime.hour;
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final suffix = hour24 >= 12 ? 'م' : 'ص';
  return '$hour12:$minute $suffix';
}
