import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KettlebellApp());
}

class KettlebellApp extends StatelessWidget {
  const KettlebellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: const HauptNavigationsPage(),
    );
  }
}

class Uebung {
  final String name;
  final String beschreibung;
  final String muskeln;
  final String kategorie;
  final String bildUrl;
  final int standardWiederholungen;

  const Uebung({
    required this.name,
    required this.beschreibung,
    required this.muskeln,
    required this.kategorie,
    required this.bildUrl,
    required this.standardWiederholungen,
  });

  static const List<Uebung> alleUebungen = [
    Uebung(name: 'Goblet Squat', beschreibung: 'Kettlebell vor der Brust halten. Fuesse schulterbreit. Gesaess nach hinten absenken.', muskeln: 'Oberschenkel, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'assets/gobletsquat.png', standardWiederholungen: 10),
    Uebung(name: 'Single-Leg Deadlift', beschreibung: 'Einbeinig stehen, Huefte nach hinten schieben, Kettlebell kontrolliert senken.', muskeln: 'Beinrueckseite, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/21/400/600', standardWiederholungen: 8),
    Uebung(name: 'Bulgarian Split Squat', beschreibung: 'Hinterer Fuss erhöht ablegen. Kettlebell vor der Brust. Tief absenken.', muskeln: 'Beine, Balance', kategorie: 'Unterkoerper', bildUrl: 'assets/bulgariansplitsquad.png', standardWiederholungen: 8),
    Uebung(name: 'Reverse Lunge', beschreibung: 'Aufrechter Stand. Weiten Schritt nach hinten machen. Knie fast zum Boden.', muskeln: 'Beine, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/23/400/600', standardWiederholungen: 10),
    Uebung(name: 'Sumo Squat', beschreibung: 'Breiter Stand, Zehen nach aussen. 3 Sek. am tiefsten Punkt halten.', muskeln: 'Adduktoren, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/24/400/600', standardWiederholungen: 12),
    Uebung(name: 'Einarmiges Rudern', beschreibung: 'Vorgebeugt, einarmig die Kugel zur Huefte ziehen. Ellbogen eng am Körper.', muskeln: 'Ruecken, Bizeps', kategorie: 'Ruecken', bildUrl: 'assets/einarmigesrudern.png', standardWiederholungen: 8),
    Uebung(name: 'Staggered Row', beschreibung: 'Versetzter Stand. Gewicht auf vorderem Bein. Einarmig rudern.', muskeln: 'Ruecken, Latissimus', kategorie: 'Ruecken', bildUrl: 'https://picsum.photos/id/26/400/600', standardWiederholungen: 8),
    Uebung(name: 'High Pull', beschreibung: 'Explosiv aus der Huefte nach oben ziehen. Ellbogen fuehrt die Bewegung.', muskeln: 'Oberer Ruecken, Schultern', kategorie: 'Ruecken', bildUrl: 'assets/highpull.png', standardWiederholungen: 10),
    Uebung(name: 'Suitcase Carry', beschreibung: 'Kettlebell einseitig halten. Aufrecht gehen, ohne zur Seite zu kippen.', muskeln: 'Ruecken, Griffkraft, Core', kategorie: 'Ruecken', bildUrl: 'https://picsum.photos/id/28/400/600', standardWiederholungen: 1),
    Uebung(name: 'Overhead Press', beschreibung: 'Aus der Rack-Position gerade nach oben druecken. Core fest halten.', muskeln: 'Schultern, Trizeps', kategorie: 'Oberkoerper', bildUrl: 'assets/overheadpress.png', standardWiederholungen: 6),
    Uebung(name: 'Push Press', beschreibung: 'Leichter Schwung aus den Beinen nutzen, um die Kugel nach oben zu druecken.', muskeln: 'Schultern, Beine', kategorie: 'Oberkoerper', bildUrl: 'https://picsum.photos/id/30/400/600', standardWiederholungen: 8),
    Uebung(name: 'Floor Press', beschreibung: 'Auf dem Boden liegend die Kugel nach oben druecken. Ellbogen beruehrt kurz Boden.', muskeln: 'Brust, Trizeps', kategorie: 'Oberkoerper', bildUrl: 'assets/floorpress.png', standardWiederholungen: 10),
    Uebung(name: 'Quarter Get-Up', beschreibung: 'Auf dem Ruecken, Arm gestreckt. Auf den Ellbogen aufrollen, Kugel fixieren.', muskeln: 'Schultern, Core', kategorie: 'Oberkoerper', bildUrl: 'https://picsum.photos/id/32/400/600', standardWiederholungen: 5),
    Uebung(name: 'Russian Twist', beschreibung: 'Sitzend, Beine leicht angehoben. Kugel von links nach rechts bewegen.', muskeln: 'Schraege Bauchmuskeln', kategorie: 'Core', bildUrl: 'https://picsum.photos/id/33/400/600', standardWiederholungen: 16),
    Uebung(name: 'Kettlebell Sit-Up', beschreibung: 'Rueckenlage, Kugel vor der Brust. Kontrolliert aufsetzen.', muskeln: 'Bauchmuskeln', kategorie: 'Core', bildUrl: 'assets/kettlebellsitup.png', standardWiederholungen: 10),
    Uebung(name: 'Plank Pull-Through', beschreibung: 'In Liegestuetzposition die Kugel unter dem Körper durchziehen.', muskeln: 'Core-Stabilitaet', kategorie: 'Core', bildUrl: 'assets/plankpullthrough.png', standardWiederholungen: 10),
    Uebung(name: 'Dead Bug', beschreibung: 'Rueckenlage, Kugel halten. Beine abwechselnd gestreckt absenken.', muskeln: 'Tiefer Core', kategorie: 'Core', bildUrl: 'assets/deadbug.png', standardWiederholungen: 10),
    Uebung(name: 'Kettlebell Swing', beschreibung: 'Hüft-Scharnier Bewegung. Kugel durch den Beinschwung auf Brusthöhe bringen.', muskeln: 'Gesaess, Ruecken, Ausdauer', kategorie: 'Ganzkoerper', bildUrl: 'assets/kettlebellswing.png', standardWiederholungen: 15),
    Uebung(name: 'Clean', beschreibung: 'Kugel explosiv vom Boden in die Rack-Position (Schulter) bringen.', muskeln: 'Ganzkoerper, Koordination', kategorie: 'Ganzkoerper', bildUrl: 'assets/clean.png', standardWiederholungen: 10),
    Uebung(name: 'Turkish Get-Up', beschreibung: 'Vom Liegen zum Stand aufstehen, waehrend die Kugel ueber Kopf gehalten wird.', muskeln: 'Ganzkoerper, Stabilitaet', kategorie: 'Ganzkoerper', bildUrl: 'https://picsum.photos/id/39/400/600', standardWiederholungen: 3),
  ];
}

// Globale Gamification-Verwaltung (wird persistiert)
class GamificationManager {
  static int xp = 0;
  static int gesamtMinuten = 0;
  static int gesamtWorkouts = 0;
  static int amrapHighscoreRunden = 0;
  static int streakWochen = 0;
  
  // Interne Variablen zur Berechnung des wöchentlichen Streaks
  static int workoutsDieseWoche = 0;
  static int letzteWocheJahr = 0; // Format: YYYYWW (z.B. 202625)

  static const List<String> levelNamen = [
    'Rostige Kugel 🥉', 'Kettlebell-Neuling 🪵', 'Eisen-Anfänger 🏋️', 'Kugel-Symphat異', 'Schwung-Lehrling 🌀',
    'Zirkel-Freund 🔄', 'Bronze-Athlet 🥉', 'Ausdauer-Sammler ⏱️', 'Schweiß-Krieger 💦', 'Gusseisen-Herz 🔥',
    'Kettlebell-Bandit 👑', 'Stahl-Muskel 💪', 'Silber-Ritter 🥈', 'Ganzkörper-Meister 🏆', 'Rep-Maschine 🤖',
    'Takt-Halter ⏱️', 'Power-Generator ⚡', 'Kugel-Flüsterer 🤫', 'Gold-Krieger 🥇', 'Schwerkraft-Trotzer 🚀',
    'Meister des Swings 🌪️', 'Unaufhaltsam 🚄', 'Titanium-Body 💎', 'Kettlebell-Legende 🌌', 'Gott des Eisens 🪐'
  ];

  static Map<String, dynamic> getLevelInfo() {
    int aktuellesLevel = 1;
    int verbleibendeXp = xp;
    int benoetigteXpFuerNaechstes = 200;

    for (int l = 1; l <= 25; l++) {
      int kosten = l * 200;
      if (verbleibendeXp >= kosten) {
        verbleibendeXp -= kosten;
        aktuellesLevel = l + 1;
      } else {
        benoetigteXpFuerNaechstes = kosten;
        break;
      }
    }
    if (aktuellesLevel > 25) {
      aktuellesLevel = 25;
      benoetigteXpFuerNaechstes = xp; // Max Level erreicht
    }

    String name = levelNamen[min(aktuellesLevel - 1, 24)];
    return {
      'level': aktuellesLevel,
      'name': name,
      'xpImLevel': verbleibendeXp,
      'benoetigteXp': benoetigteXpFuerNaechstes,
      'fortschritt': min(1.0, verbleibendeXp / benoetigteXpFuerNaechstes)
    };
  }

  static int getKW(DateTime date) {
    // Einfache ISO-Wochennummer-Berechnung
    final dayTarget = DateTime(date.year, date.month, date.day - (date.weekday - 1) + 3);
    final firstThursday = DateTime(dayTarget.year, 1, 4);
    final firstThursdayTarget = DateTime(firstThursday.year, firstThursday.month, firstThursday.day - (firstThursday.weekday - 1) + 3);
    final weekNum = ((dayTarget.difference(firstThursdayTarget).inDays / 7).floor()) + 1;
    return date.year * 100 + weekNum;
  }

  static Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('g_xp') ?? 0;
    gesamtMinuten = prefs.getInt('g_minuten') ?? 0;
    gesamtWorkouts = prefs.getInt('g_workouts') ?? 0;
    amrapHighscoreRunden = prefs.getInt('g_amrap_highscore') ?? 0;
    streakWochen = prefs.getInt('g_streak') ?? 0;
    workoutsDieseWoche = prefs.getInt('g_workouts_woche') ?? 0;
    letzteWocheJahr = prefs.getInt('g_letzte_woche_jahr') ?? 0;

    // Überprüfen, ob eine neue Woche angefangen hat
    int aktuelleKW = getKW(DateTime.now());
    if (aktuelleKW != letzteWocheJahr) {
      // Wenn in der alten Woche das Soll von 2 Workouts nicht erfüllt wurde -> Streak reißt ab
      if (letzteWocheJahr != 0 && workoutsDieseWoche < 2) {
        streakWochen = 0;
      }
      workoutsDieseWoche = 0;
      letzteWocheJahr = aktuelleKW;
      await saveStats();
    }
  }

  static Future<void> saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('g_xp', xp);
    await prefs.setInt('g_minuten', gesamtMinuten);
    await prefs.setInt('g_workouts', gesamtWorkouts);
    await prefs.setInt('g_amrap_highscore', amrapHighscoreRunden);
    await prefs.setInt('g_streak', streakWochen);
    await prefs.setInt('g_workouts_woche', workoutsDieseWoche);
    await prefs.setInt('g_letzte_woche_jahr', letzteWocheJahr);
  }

  static Future<void> addWorkoutErgebnis({required int minuten, required int amrapRunden, required bool isAmrap}) async {
    await loadStats();

    gesamtWorkouts++;
    gesamtMinuten += minuten;
    
    // XP Berechnung: 1 Minute = 10 XP. Jede AMRAP-Runde = 20 XP zusätzlich.
    int verdienteXp = minuten * 10;
    if (isAmrap) {
      verdienteXp += amrapRunden * 20;
      if (amrapRunden > amrapHighscoreRunden) {
        amrapHighscoreRunden = amrapRunden;
      }
    }
    xp += verdienteXp;

    // Streak-Logik (2 Workouts pro Woche nötig)
    workoutsDieseWoche++;
    if (workoutsDieseWoche == 2) {
      streakWochen++; // Streak erhöht sich, sobald das Wochenziel erreicht ist
    }

    await saveStats();
  }

  static List<Map<String, dynamic>> checkAchievements() {
    int lvl = getLevelInfo()['level'];
    return [
      {'id': 1, 'titel': 'Erstkontakt 🚀', 'sub': 'Dein allererstes Kugel-Workout abgeschlossen.', 'done': gesamtWorkouts >= 1, 'icon': Icons.rocket_launch},
      {'id': 2, 'titel': 'Kettlebell-Lehrling ⏱️', 'sub': 'Insgesamt 50 Minuten trainiert.', 'done': gesamtMinuten >= 50, 'icon': Icons.timer},
      {'id': 3, 'titel': 'Ausdauer-Monster 🐉', 'sub': 'Insgesamt 200 Minuten trainiert.', 'done': gesamtMinuten >= 200, 'icon': Icons.workspace_premium},
      {'id': 4, 'titel': 'Zirkel-Starter 🔄', 'sub': 'Dein erstes AMRAP-Workout beendet.', 'done': amrapHighscoreRunden >= 1, 'icon': Icons.loop},
      {'id': 5, 'titel': 'Zirkel-Meister 👑', 'sub': 'Schaffe im AMRAP mindestens 6 Runden.', 'done': amrapHighscoreRunden >= 6, 'icon': Icons.military_tech},
      {'id': 6, 'titel': 'Zeit-Krieger 🛡️', 'sub': 'Ein langes AMRAP (>= 20 Min) durchgezogen.', 'done': gesamtMinuten >= 20 && amrapHighscoreRunden >= 1, 'icon': Icons.shield},
      {'id': 7, 'titel': 'Beständigkeit 🔥', 'sub': 'Erreiche einen 2-Wochen-Streak.', 'done': streakWochen >= 2, 'icon': Icons.local_fire_department},
      {'id': 8, 'titel': 'Eiserner Wille 💎', 'sub': 'Erreiche einen 4-Wochen-Streak.', 'done': streakWochen >= 4, 'icon': Icons.diamond},
      {'id': 9, 'titel': 'Fleißbiene 🐝', 'sub': 'Absolviere insgesamt 10 Workouts.', 'done': gesamtWorkouts >= 10, 'icon': Icons.fitness_center},
      {'id': 10, 'titel': 'Banditen-König 👑', 'sub': 'Erreiche Level 10 der Hierarchie.', 'done': lvl >= 10, 'icon': Icons.auto_awesome},
    ];
  }
}

class HauptNavigationsPage extends StatefulWidget {
  const HauptNavigationsPage({super.key});
  @override
  _HauptNavigationsPageState createState() => _HauptNavigationsPageState();
}

class _HauptNavigationsPageState extends State<HauptNavigationsPage> {
  int _aktuellerIndex = 0;
  final List<Widget> _seiten = [const SlotMachinePage(), const MediathekPage(), const StatistikPage()];

  @override
  void initState() {
    super.initState();
    GamificationManager.loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _seiten[_aktuellerIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktuellerIndex,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() {
            _aktuellerIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Slot Machine'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Mediathek'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Statistik'),
        ],
      ),
    );
  }
}

class SlotMachinePage extends StatefulWidget {
  const SlotMachinePage({super.key});
  @override
  _SlotMachinePageState createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends State<SlotMachinePage> {
  List<Uebung?> _aktuellesWorkout = [null, null, null, null, null];
  String _workoutModus = 'EMOM';
  int _amrapMinuten = 15;
  Map<String, int> _geladeneReps = {};

  @override
  void initState() {
    super.initState();
    _loadAllReps();
  }

  Future<void> _loadAllReps() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var u in Uebung.alleUebungen) {
        _geladeneReps[u.name] = prefs.getInt('reps_${u.name}') ?? u.standardWiederholungen;
      }
    });
  }

  void _spin() {
    final r = Random();
    setState(() {
      _aktuellesWorkout = [
        Uebung.alleUebungen[r.nextInt(5)],       
        Uebung.alleUebungen[5 + r.nextInt(4)],   
        Uebung.alleUebungen[9 + r.nextInt(4)],   
        Uebung.alleUebungen[13 + r.nextInt(4)],  
        Uebung.alleUebungen[17 + r.nextInt(3)],  
      ];
      _aktuellesWorkout.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎰 One-kettled bandit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Dein Workout:', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 15),
            Column(
              children: _aktuellesWorkout.asMap().entries.map((e) {
                final reps = _geladeneReps[e.value?.name] ?? e.value?.standardWiederholungen ?? 0;
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.orange, child: Text('${e.key + 1}', style: const TextStyle(color: Colors.black))),
                    title: Text(e.value?.name ?? '?', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(e.value?.kategorie ?? 'Kategorie wählen'),
                    trailing: e.value != null 
                        ? Text('$reps Reps', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _spin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              child: const Text('SPIN!', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            if (!_aktuellesWorkout.contains(null)) ...[
              const SizedBox(height: 25),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              const Text('Wähle deinen Workout-Modus:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('⏱️ EMOM'),
                    selected: _workoutModus == 'EMOM',
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(color: _workoutModus == 'EMOM' ? Colors.black : Colors.white),
                    onSelected: (s) => setState(() => _workoutModus = 'EMOM'),
                  ),
                  const SizedBox(width: 15),
                  ChoiceChip(
                    label: const Text('🔄 AMRAP'),
                    selected: _workoutModus == 'AMRAP',
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(color: _workoutModus == 'AMRAP' ? Colors.black : Colors.white),
                    onSelected: (s) => setState(() => _workoutModus = 'AMRAP'),
                  ),
                ],
              ),
              if (_workoutModus == 'AMRAP') ...[
                const SizedBox(height: 10),
                Text('AMRAP Zeit: $_amrapMinuten Minuten', style: const TextStyle(color: Colors.grey)),
                Slider(
                  value: _amrapMinuten.toDouble(),
                  min: 5,
                  max: 30,
                  divisions: 5,
                  activeColor: Colors.orange,
                  inactiveColor: Colors.grey[800],
                  onChanged: (v) => setState(() => _amrapMinuten = v.toInt()),
                ),
              ],
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  _loadAllReps().then((_) {
                    if (_workoutModus == 'EMOM') {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => AktiverEMOMBildschirm(aktuellesWorkout: _aktuellesWorkout.cast<Uebung>(), repsMap: _geladeneReps)));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => AktiverAMRAPBildschirm(aktuellesWorkout: _aktuellesWorkout.cast<Uebung>(), gesamtMinuten: _amrapMinuten, repsMap: _geladeneReps)));
                    }
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                child: Text(_workoutModus == 'EMOM' ? 'START EMOM ▶️' : 'START AMRAP ▶️', style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class AktiverEMOMBildschirm extends StatefulWidget {
  final List<Uebung> aktuellesWorkout;
  final Map<String, int> repsMap;
  const AktiverEMOMBildschirm({super.key, required this.aktuellesWorkout, required this.repsMap});
  @override
  _AktiverEMOMBildschirmState createState() => _AktiverEMOMBildschirmState();
}

class _AktiverEMOMBildschirmState extends State<AktiverEMOMBildschirm> {
  int _index = 0;
  int _sekunden = 60;
  int _minutenGespielt = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_sekunden > 1) {
        setState(() => _sekunden--);
      } else {
        setState(() {
          _sekunden = 60;
          _minutenGespielt++;
          if (_minutenGespielt >= 30) {
            _timer?.cancel();
            _beendet(complete: true);
          } else {
            _index = (_index + 1) % 5;
          }
        });
      }
    });
  }

  void _beendet({required bool complete}) async {
    if (complete && _minutenGespielt > 0) {
      await GamificationManager.addWorkoutErgebnis(minuten: _minutenGespielt, amrapRunden: 0, isAmrap: false);
    }
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('🎉 Fertig!'), 
        content: Text('$_minutenGespielt Minuten EMOM erfolgreich absolviert und XP gesichert!'), 
        actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('OK'))]
      )
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.aktuellesWorkout[_index];
    final zielReps = widget.repsMap[u.name] ?? u.standardWiederholungen;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(u.bildUrl, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, size: 100, color: Colors.orange)),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(u.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange)),
                    const SizedBox(height: 5),
                    Text('ZIEL: $zielReps WIEDERHOLUNGEN', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(u.beschreibung, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                    const Spacer(),
                    Text('0:${_sekunden.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Fortschritt: $_minutenGespielt/30 Min', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _timer?.cancel();
                            _beendet(complete: true); // Vorzeitig beenden sichert die gespielten Minuten!
                          }, 
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]), 
                          child: const Text('Workout Beenden')
                        ),
                        ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.red[900]), child: const Text('Abbrechen')),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AktiverAMRAPBildschirm extends StatefulWidget {
  final List<Uebung> aktuellesWorkout;
  final int gesamtMinuten;
  final Map<String, int> repsMap;

  const AktiverAMRAPBildschirm({super.key, required this.aktuellesWorkout, required this.gesamtMinuten, required this.repsMap});

  @override
  _AktiverAMRAPBildschirmState createState() => _AktiverAMRAPBildschirmState();
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
    if (gespielteMinuten == 0 && _gesamtSekunden > 0) gespielteMinuten = 1; // Mindestens 1 Min Gutschrift

    await GamificationManager.addWorkoutErgebnis(minuten: gespielteMinuten, amrapRunden: _rundenZaehler, isAmrap: true);
    
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('⏱️ Zeit um / Beendet!'), 
        content: Text('Hervorragend! Du hast in $gespielteMinuten Minuten stolze $_rundenZaehler Runden geschafft und massive XP erhalten!'), 
        actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Wahnsinn!'))]
      )
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
              child: Image.asset(u.bildUrl, height: 180, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, size: 80, color: Colors.orange)),
            ),
            const SizedBox(height: 15),
            Text(u.beschreibung, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Zurück zum Workout ↩️', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)))
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
                        _beendet(); // Manuelles Beenden sichert den aktuellen Fortschritt!
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

class MediathekPage extends StatefulWidget {
  const MediathekPage({super.key});
  @override
  _MediathekPageState createState() => _MediathekPageState();
}

class _MediathekPageState extends State<MediathekPage> {
  String _filter = 'Alle';
  Map<String, int> _customReps = {};

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
          DropdownButton<String>(
            value: _filter,
            onChanged: (v) => setState(() => _filter = v!),
            items: ['Alle', 'Unterkoerper', 'Ruecken', 'Oberkoerper', 'Core', 'Ganzkoerper'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
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
                          child: u.bildUrl.startsWith('http') ? Image.network(u.bildUrl) : Image.asset(u.bildUrl, errorBuilder: (c,e,s) => const Icon(Icons.fitness_center, size: 100)),
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
                        child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () {
                          this.setState(() {});
                          Navigator.pop(context);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    ).then((_) => setState(() {}));
  }
}

// DIE NEUE GAMIFIED STATISTIK SEITE
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
            // LEVEL SYSTEM CARD
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

            // STATS & STREAK ROW
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

            // TROPHÄEN WAND ÜBERSCHRIFT
            const Text('🏆 Trophäen-Wand (Achievements)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),

            // GRID FÜR DIE 10 ACHIEVEMENTS
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
                      // Badge Icon Design mit reinem Flutter Code
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
                            size: 22
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
                          color: done ? Colors.white : Colors.grey[600]
                        )
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
