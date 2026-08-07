import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KettlebellApp());
}

class KettlebellApp extends StatelessWidget {
  const KettlebellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kettlebell & Gamification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.orange,
          secondary: Colors.orangeAccent,
        ),
      ),
      home: const HauptMenuePage(),
    );
  }
}

// ==========================================
// DATENMODELL: UEBUNG
// ==========================================
class Uebung {
  final String name;
  final String kategorie;
  final int standardWiederholungen;
  final String bildUrl;
  final String beschreibung;

  Uebung({
    required this.name,
    required this.kategorie,
    required this.standardWiederholungen,
    required this.bildUrl,
    required this.beschreibung,
  });

  static List<Uebung> alleUebungen = [
    Uebung(
      name: 'Kettlebell Swing',
      kategorie: 'Ganzkoerper',
      standardWiederholungen: 15,
      bildUrl: 'https://via.placeholder.com/180',
      beschreibung: 'Hüftdominante Bewegung. Rücken gerade halten, Explosivität aus der Hüfte nutzen.',
    ),
    Uebung(
      name: 'Goblet Squat',
      kategorie: 'Unterkoerper',
      standardWiederholungen: 10,
      bildUrl: 'https://via.placeholder.com/180',
      beschreibung: 'Kettlebell vor der Brust halten, tief beugen, Knie zeigen nach außen.',
    ),
    Uebung(
      name: 'Overhead Press',
      kategorie: 'Oberkoerper',
      standardWiederholungen: 8,
      bildUrl: 'https://via.placeholder.com/180',
      beschreibung: 'Kettlebell aus der Rack-Position strikt über den Kopf drücken. Core anspannen.',
    ),
    Uebung(
      name: 'Single Arm Row',
      kategorie: 'Ruecken',
      standardWiederholungen: 10,
      bildUrl: 'https://via.placeholder.com/180',
      beschreibung: 'Vorgebeugt abstützen, Kettlebell dynamisch zur Hüfte ziehen.',
    ),
    Uebung(
      name: 'Russian Twist',
      kategorie: 'Core',
      standardWiederholungen: 20,
      bildUrl: 'https://via.placeholder.com/180',
      beschreibung: 'Auf den Boden setzen, Oberkörper leicht zurücklehnen, Gewicht seitlich rotieren.',
    ),
  ];
}

// ==========================================
// GAMIFICATION MANAGER
// ==========================================
class GamificationManager {
  static int xp = 0;
  static int gesamtWorkouts = 0;
  static int gesamtMinuten = 0;
  static int streakWochen = 0;

  static Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('xp') ?? 0;
    gesamtWorkouts = prefs.getInt('gesamtWorkouts') ?? 0;
    gesamtMinuten = prefs.getInt('gesamtMinuten') ?? 0;
    streakWochen = prefs.getInt('streakWochen') ?? 0;
  }

  static Future<void> addWorkoutErgebnis({
    required int minuten,
    required int amrapRunden,
    required bool isAmrap,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // XP Berechnung: 10 XP pro Min + 25 XP pro Runden
    int erhalteneXp = (minuten * 10) + (amrapRunden * 25);
    xp += erhalteneXp;
    gesamtWorkouts += 1;
    gesamtMinuten += minuten;

    await prefs.setInt('xp', xp);
    await prefs.setInt('gesamtWorkouts', gesamtWorkouts);
    await prefs.setInt('gesamtMinuten', gesamtMinuten);
  }

  static Map<String, dynamic> getLevelInfo() {
    int level = (xp ~/ 300) + 1;
    int xpImLevel = xp % 300;
    int benoetigteXp = 300;
    double fortschritt = xpImLevel / benoetigteXp;

    String levelName = 'Anfänger';
    if (level > 3) levelName = 'Kettlebell Fortgeschrittener';
    if (level > 7) levelName = 'Eisen-Athlet';
    if (level > 10) levelName = 'Master of Swing';

    return {
      'level': level,
      'name': levelName,
      'xpImLevel': xpImLevel,
      'benoetigteXp': benoetigteXp,
      'fortschritt': fortschritt > 1.0 ? 1.0 : fortschritt,
    };
  }

  static List<Map<String, dynamic>> checkAchievements() {
    return [
      {
        'titel': 'Erster Schritt',
        'sub': 'Schließe 1 Workout ab',
        'icon': Icons.star,
        'done': gesamtWorkouts >= 1,
      },
      {
        'titel': 'Dauerbrenner',
        'sub': '30 Minuten Gesamttraining',
        'icon': Icons.timer,
        'done': gesamtMinuten >= 30,
      },
      {
        'titel': 'XP Sammler',
        'sub': 'Erreiche 500 Gesamt-XP',
        'icon': Icons.bolt,
        'done': xp >= 500,
      },
      {
        'titel': 'Kettlebell Meister',
        'sub': 'Schließe 10 Workouts ab',
        'icon': Icons.fitness_center,
        'done': gesamtWorkouts >= 10,
      },
    ];
  }
}

// ==========================================
// HAUPTMENÜ SCREEN
// ==========================================
class HauptMenuePage extends StatelessWidget {
  const HauptMenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏋️ Kettlebell Workout App')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('AMRAP Workout Starten (10 Min)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => AktiverAMRAPBildschirm(
                      gesamtMinuten: 10,
                      aktuellesWorkout: Uebung.alleUebungen,
                      repsMap: const {},
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.library_books),
              label: const Text('Übungs-Mediathek'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(18)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const MediathekPage()));
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Fitness Zentrale (Statistik)'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(18)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => const StatistikPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 1: AKTIVER AMRAP BILDSCHIRM
// ==========================================
class AktiverAMRAPBildschirm extends StatefulWidget {
  final int gesamtMinuten;
  final List<Uebung> aktuellesWorkout;
  final Map<String, int> repsMap;

  const AktiverAMRAPBildschirm({
    super.key,
    required this.gesamtMinuten,
    required this.aktuellesWorkout,
    required this.repsMap,
  });

  @override
  State<AktiverAMRAPBildschirm> createState() => _AktiverAMRAPBildschirmState();
}

class _AktiverAMRAPBildschirmState extends State<AktiverAMRAPBildschirm> {
  int _gesamtSekunden = 0;
  int _rundenZaehler = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _gesamtSekunden = widget.gesamtMinuten * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_gesamtSekunden > 1) {
        setState(() => _gesamtSekunden--);
      } else {
        _timer?.cancel();
        _beendet();
      }
    });
  }

  void _beendet() async {
    int gespielteMinuten = widget.gesamtMinuten - (_gesamtSekunden ~/ 60);
    if (gespielteMinuten == 0 && _gesamtSekunden > 0) gespielteMinuten = 1;

    await GamificationManager.addWorkoutErgebnis(
      minuten: gespielteMinuten,
      amrapRunden: _rundenZaehler,
      isAmrap: true,
    );

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('⏱️ Zeit um / Beendet!'),
        content: Text('Hervorragend! Du hast in $gespielteMinuten Minuten stolze $_rundenZaehler Runden geschafft und massive XP erhalten!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Wahnsinn!'),
          )
        ],
      ),
    );
  }

  void _zeigeUebungsInfo(Uebung u) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[950],
        title: Text(u.name, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: u.bildUrl.startsWith('http')
                  ? Image.network(u.bildUrl, height: 180, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, size: 80, color: Colors.orange))
                  : Image.asset(u.bildUrl, height: 180, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, size: 80, color: Colors.orange)),
            ),
            const SizedBox(height: 15),
            Text(u.beschreibung, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zurück zum Workout ↩️', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int sekunden) {
    int m = sekunden ~/ 60;
    int s = sekunden % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔄 AMRAP Zirkel-Board'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              color: Colors.grey[950],
              width: double.infinity,
              child: Column(
                children: [
                  Text(_formatTime(_gesamtSekunden), style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.orange)),
                  Text('Verbleibende Zeit von ${widget.gesamtMinuten} Min', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  Text('Abgeschlossene Runden: $_rundenZaehler', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: widget.aktuellesWorkout.length,
                itemBuilder: (context, idx) {
                  final u = widget.aktuellesWorkout[idx];
                  final reps = widget.repsMap[u.name] ?? u.standardWiederholungen;
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      onTap: () => _zeigeUebungsInfo(u),
                      leading: CircleAvatar(backgroundColor: Colors.orange[800], child: Text('${idx + 1}', style: const TextStyle(color: Colors.white))),
                      title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: const Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Anleitung zeigen', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                        child: Text('$reps Reps', style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _timer?.cancel();
                        _beendet();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800], padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('Beenden', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[900], padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('Abbrechen', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _rundenZaehler++),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: const EdgeInsets.symmetric(vertical: 20)),
                      child: const Text('RUNDEN (+1) 🏁', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: MEDIATHEK PAGE
// ==========================================
class MediathekPage extends StatefulWidget {
  const MediathekPage({super.key});
  @override
  State<MediathekPage> createState() => _MediathekPageState();
}

class _MediathekPageState extends State<MediathekPage> {
  String _filter = 'Alle';
  final Map<String, int> _customReps = {};

  @override
  void initState() {
    super.initState();
    _loadSavedReps();
  }

  Future<void> _loadSavedReps() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var u in Uebung.alleUebungen) {
        _customReps[u.name] = prefs.getInt('reps_${u.name}') ?? u.standardWiederholungen;
      }
    });
  }

  Future<void> _updateReps(String name, int neuWert) async {
    if (neuWert < 1) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reps_$name', neuWert);
    setState(() {
      _customReps[name] = neuWert;
    });
  }

  @override
  Widget build(BuildContext context) {
    final liste = Uebung.alleUebungen.where((u) => _filter == 'Alle' || u.kategorie == _filter).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Mediathek')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _filter,
              isExpanded: true,
              onChanged: (v) => setState(() => _filter = v!),
              items: ['Alle', 'Unterkoerper', 'Ruecken', 'Oberkoerper', 'Core', 'Ganzkoerper']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: liste.length,
              itemBuilder: (c, i) {
                final u = liste[i];
                final aktuelleReps = _customReps[u.name] ?? u.standardWiederholungen;
                return ListTile(
                  title: Text(u.name),
                  subtitle: Text(u.kategorie),
                  trailing: Text('$aktuelleReps Reps', style: const TextStyle(color: Colors.orange)),
                  onTap: () => _showDetails(context, u),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, Uebung u) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalState) {
            final aktuelleReps = _customReps[u.name] ?? u.standardWiederholungen;
            return DraggableScrollableSheet(
              initialChildSize: 0.95,
              builder: (context, scrollController) => Container(
                decoration: BoxDecoration(color: Colors.grey[950], borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                child: Stack(
                  children: [
                    ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        const SizedBox(height: 40),
                        Text(u.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 5),
                        Text(u.kategorie, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Wiederholungen:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                                    onPressed: () async {
                                      await _updateReps(u.name, aktuelleReps - 1);
                                      modalState(() {});
                                    },
                                  ),
                                  Text('$aktuelleReps', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                                    onPressed: () async {
                                      await _updateReps(u.name, aktuelleReps + 1);
                                      modalState(() {});
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: u.bildUrl.startsWith('http')
                              ? Image.network(u.bildUrl, errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, size: 100))
                              : Image.asset(u.bildUrl, errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, size: 100)),
                        ),
                        const SizedBox(height: 20),
                        const Text('Ausführung:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                        const SizedBox(height: 10),
                        Text(u.beschreibung, style: const TextStyle(fontSize: 16, height: 1.5)),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) => setState(() {}));
  }
}

// ==========================================
// SCREEN 3: STATISTIK PAGE
// ==========================================
class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  @override
  void initState() {
    super.initState();
    GamificationManager.loadStats().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final lvlInfo = GamificationManager.getLevelInfo();
    final achievements = GamificationManager.checkAchievements();

    return Scaffold(
      appBar: AppBar(title: const Text('💪 Fitness Zentrale')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.grey[900]!, Colors.grey[850]!]),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LEVEL ${lvlInfo['level']}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange)),
                      Text('${GamificationManager.xp} Gesamt-XP', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(lvlInfo['name'], style: const TextStyle(fontSize: 16, color: Colors.white70, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: lvlInfo['fortschritt'],
                      minHeight: 12,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${lvlInfo['xpImLevel']} XP', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Nächstes Level bei: ${lvlInfo['benoetigteXp']} XP', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Icon(Icons.local_fire_department, color: GamificationManager.streakWochen > 0 ? Colors.red : Colors.grey, size: 36),
                        const SizedBox(height: 5),
                        Text('${GamificationManager.streakWochen} Wochen', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('Streak (>=2x/W)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Icon(Icons.fitness_center, color: Colors.green, size: 36),
                        const SizedBox(height: 5),
                        Text('${GamificationManager.gesamtWorkouts}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('Workouts', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Icon(Icons.timer, color: Colors.blue, size: 36),
                        const SizedBox(height: 5),
                        Text('${GamificationManager.gesamtMinuten}m', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('Gesamtzeit', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text('🏆 Trophäen-Wand (Achievements)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemCount: achievements.length,
              itemBuilder: (context, idx) {
                final ach = achievements[idx];
                final bool done = ach['done'];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: done ? Colors.grey[900] : Colors.grey[950]!.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: done ? Colors.orange.withOpacity(0.6) : Colors.grey[900]!,
                      width: done ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: done
                                  ? const LinearGradient(colors: [Colors.amber, Colors.orange])
                                  : LinearGradient(colors: [Colors.grey[800]!, Colors.grey[700]!]),
                            ),
                          ),
                          Icon(
                            done ? ach['icon'] : Icons.lock,
                            color: done ? Colors.black : Colors.grey[500],
                            size: 22,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ach['titel'],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: done ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ach['sub'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: done ? Colors.grey[400] : Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
