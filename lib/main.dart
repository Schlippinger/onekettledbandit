import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OneKettledBanditApp());
}

/// Globale Modell-Klasse für eine Kettlebell-Übung
class Uebung {
  final String id;
  final String name;
  final String imagePath;
  final String beschreibung;
  int reps;

  Uebung({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.beschreibung,
    this.reps = 10,
  });
}

/// Globale Übungs-Datenbank mit deinen 22 eigenen PNG-Bildern
final List<Uebung> globaleUebungen = [
  Uebung(
    id: 'bulgariansplitsquad',
    name: 'Bulgarian Split Squat',
    imagePath: 'assets/images/bulgariansplitsquad.png',
    beschreibung:
        'Ein Bein hinten auf einer Erhöhung ablegen. Das vordere Bein beugen, bis das hintere Knie fast den Boden berührt, dann kraftvoll hochdrücken.',
    reps: 8,
  ),
  Uebung(
    id: 'clean',
    name: 'Clean',
    imagePath: 'assets/images/clean.png',
    beschreibung:
        'Die Kettlebell durch den Hüftschwung nach oben führen und nahe am Körper sanft in der Rack-Position auf der Brust fangen.',
    reps: 10,
  ),
  Uebung(
    id: 'deadbug',
    name: 'Deadbug',
    imagePath: 'assets/images/deadbug.png',
    beschreibung:
        'Auf dem Rücken liegen, Arme und Beine im 90°-Winkel anheben. Diagonal Arm und Bein kontrolliert zum Boden absenken, während der untere Rücken flach aufliegt.',
    reps: 12,
  ),
  Uebung(
    id: 'einarmigesrudern',
    name: 'Einarmiges Rudern',
    imagePath: 'assets/images/einarmigesrudern.png',
    beschreibung:
        'Leicht vorgebeugt mit geradem Rücken aufstützen. Die Kettlebell seitlich am Körper entlang zum Becken ziehen.',
    reps: 10,
  ),
  Uebung(
    id: 'floorpress',
    name: 'Floor Press',
    imagePath: 'assets/images/floorpress.png',
    beschreibung:
        'Flach auf den Rücken legen, Füße aufstellen. Die Kettlebell wie beim Bankdrücken von der Brust nach oben drücken.',
    reps: 10,
  ),
  Uebung(
    id: 'gobletsquat',
    name: 'Goblet Squat',
    imagePath: 'assets/images/gobletsquat.png',
    beschreibung:
        'Die Kettlebell vor der Brust halten. Aufrecht in die Kniebeuge gehen, Hüfte unter Kniehöhe absenken und wieder aufstehen.',
    reps: 12,
  ),
  Uebung(
    id: 'highpull',
    name: 'High Pull',
    imagePath: 'assets/images/highpull.png',
    beschreibung:
        'Aus dem Swing heraus die Kettlebell auf Brust- bis Kinn-Höhe ziehen, der Ellbogen führt die Bewegung nach oben-außen an.',
    reps: 10,
  ),
  Uebung(
    id: 'kettlebellsitup',
    name: 'Kettlebell Sit-Up',
    imagePath: 'assets/images/kettlebellsitup.png',
    beschreibung:
        'Auf den Rücken legen, Kettlebell vor der Brust oder über dem Kopf halten. Aus der Rumpfmuskulatur aufrichten.',
    reps: 12,
  ),
  Uebung(
    id: 'kettlebellswing',
    name: 'Kettlebell Swing',
    imagePath: 'assets/images/kettlebellswing.png',
    beschreibung:
        'Dynamischer Hüftschwung (Hinge-Bewegung). Die Kraft kommt explizit aus Gesäß und Beinrückseite, nicht aus den Armen.',
    reps: 15,
  ),
  Uebung(
    id: 'overheadpress',
    name: 'Overhead Press',
    imagePath: 'assets/images/overheadpress.png',
    beschreibung:
        'Aus der Rack-Position auf Brusthöhe die Kettlebell kontrolliert direkt über den Kopf nach oben drücken.',
    reps: 8,
  ),
  Uebung(
    id: 'plankpullthrough',
    name: 'Plank Pull Through',
    imagePath: 'assets/images/plankpullthrough.png',
    beschreibung:
        'In der Liegestütz-Position die Kettlebell unter dem Körper hindurch von einer Seite zur anderen ziehen.',
    reps: 10,
  ),
  Uebung(
    id: 'plankrow',
    name: 'Plank Row',
    imagePath: 'assets/images/plankrow.png',
    beschreibung:
        'In der Liegestütz-Position abwechselnd eine Seite stabil zum Körper rudern.',
    reps: 10,
  ),
  Uebung(
    id: 'pushpress',
    name: 'Push Press',
    imagePath: 'assets/images/pushpress.png',
    beschreibung:
        'Leichten Impuls aus den Knien nutzen, um die Kettlebell schwungvoll über den Kopf zu drücken.',
    reps: 10,
  ),
  Uebung(
    id: 'quartergetup',
    name: 'Quarter Get-Up',
    imagePath: 'assets/images/quartergetup.png',
    beschreibung:
        'Erster Teil des Turkish Get-Up: Auf dem Rücken liegend die Kugel nach oben drücken und kontrolliert auf den Unterarm/Hand aufrichten.',
    reps: 5,
  ),
  Uebung(
    id: 'reverselunge',
    name: 'Reverse Lunge',
    imagePath: 'assets/images/reverselunge.png',
    beschreibung:
        'Einen Schritt nach hinten machen, beide Knie auf ca. 90° beugen und wieder in den Stand zurückkehren.',
    reps: 10,
  ),
  Uebung(
    id: 'romaniandeadlift',
    name: 'Romanian Deadlift',
    imagePath: 'assets/images/romaniandeadlift.png',
    beschreibung:
        'Mit leicht gebeugten Knien die Hüfte nach hinten schieben, den Oberkörper mit geradem Rücken absenken und wieder aufrichten.',
    reps: 12,
  ),
  Uebung(
    id: 'russiantwist',
    name: 'Russian Twist',
    imagePath: 'assets/images/russiantwist.png',
    beschreibung:
        'Im Sitzen leicht nach hinten lehnen und die Kettlebell kontrolliert von der linken zur rechten Seite führen.',
    reps: 16,
  ),
  Uebung(
    id: 'singlelegdeadlift',
    name: 'Single Leg Deadlift',
    imagePath: 'assets/images/singlelegdeadlift.png',
    beschreibung:
        'Auf einem Bein stehend das andere Bein nach hinten strecken, während der Oberkörper nach vorne kippt und die Kugel geführt wird.',
    reps: 8,
  ),
  Uebung(
    id: 'staggeredrow',
    name: 'Staggered Row',
    imagePath: 'assets/images/staggeredrow.png',
    beschreibung:
        'In versetzter Fußstellung (Schrittstellung) vorgebeugt stehen und die Kettlebell kontrolliert zur Hüfte rudern.',
    reps: 10,
  ),
  Uebung(
    id: 'suitcasecarry',
    name: 'Suitcase Carry',
    imagePath: 'assets/images/suitcasecarry.png',
    beschreibung:
        'Kettlebell wie einen Koffer in einer Hand halten. Aufrecht gehen, ohne zur Seite zu kippen.',
    reps: 20,
  ),
  Uebung(
    id: 'sumosquat',
    name: 'Sumo Squat',
    imagePath: 'assets/images/sumosquat.png',
    beschreibung:
        'Breiter Stand, Fußspitzen nach außen gedreht. Tief in die Kniebeuge gehen und die Kettlebell mittig führen.',
    reps: 12,
  ),
  Uebung(
    id: 'turkishgetup',
    name: 'Turkish Get-Up',
    imagePath: 'assets/images/turkishgetup.png',
    beschreibung:
        'Komplexe Abfolge vom Liegen auf dem Rücken bis zum vollen Stand mit permanent gestrecktem Arm über dem Kopf.',
    reps: 3,
  ),
];

// Globale Statistik-Speicherung
int globalAbgeschlosseneWorkouts = 0;
int globalGesamtTrainingsminuten = 0;

class OneKettledBanditApp extends StatelessWidget {
  const OneKettledBanditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'onekettled_bandit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      home: const HauptmenueScreen(),
    );
  }
}

/// Helper-Funktion: Zeigt das Detail-Modal mit Bild und Beschreibung
void showUebungDetailDialog(BuildContext context, Uebung uebung) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          uebung.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  uebung.imagePath,
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.fitness_center, size: 50, color: Colors.amber),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                uebung.beschreibung,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen', style: TextStyle(color: Colors.amber)),
          ),
        ],
      );
    },
  );
}

class HauptmenueScreen extends StatefulWidget {
  const HauptmenueScreen({super.key});

  @override
  State<HauptmenueScreen> createState() => _HauptmenueScreenState();
}

class _HauptmenueScreenState extends State<HauptmenueScreen> {
  @override
  void initState() {
    super.initState();
    _loadCustomReps();
  }

  Future<void> _loadCustomReps() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var uebung in globaleUebungen) {
        int? savedReps = prefs.getInt('reps_${uebung.id}');
        if (savedReps != null) {
          uebung.reps = savedReps;
        }
      }
    });
  }

  List<Uebung> _zieheZufallsUebungen() {
    final list = List<Uebung>.from(globaleUebungen);
    list.shuffle(Random());
    return list.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OneKettled Bandit 🎰', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.casino, size: 48, color: Colors.amber),
                    SizedBox(height: 8),
                    Text(
                      'Bereit für das nächste Workout?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Lass den Zufall über deine 5 Übungen entscheiden.',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.vertical: 16),
              icon: const Icon(Icons.timer),
              label: const Text('EMOM Workout starten (30 Min)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {
                final gezogene = _zieheZufallsUebungen();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmomWorkoutScreen(uebungen: gezogene),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.vertical: 16),
              icon: const Icon(Icons.repeat),
              label: const Text('AMRAP Workout starten', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {
                final gezogene = _zieheZufallsUebungen();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AmrapConfigScreen(uebungen: gezogene),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber,
                padding: const EdgeInsets.vertical: 16,
                side: const BorderSide(color: Colors.amber),
              ),
              icon: const Icon(Icons.fitness_center),
              label: const Text('Mediathek & Reps anpassen', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MediathekScreen(),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
            const Spacer(),
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Workouts', style: TextStyle(color: Colors.grey)),
                        Text('$globalAbgeschlosseneWorkouts', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Trainingszeit', style: TextStyle(color: Colors.grey)),
                        Text('$globalGesamtTrainingsminuten Min.', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AMRAP Konfigurations-Screen
class AmrapConfigScreen extends StatefulWidget {
  final List<Uebung> uebungen;
  const AmrapConfigScreen({super.key, required this.uebungen});

  @override
  State<AmrapConfigScreen> createState() => _AmrapConfigScreenState();
}

class _AmrapConfigScreenState extends State<AmrapConfigScreen> {
  int _dauerMinuten = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AMRAP Konfiguration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.stretch,
          children: [
            const Text(
              'Wähle die Dauer des Workouts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$_dauerMinuten Minuten', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
              ],
            ),
            Slider(
              value: _dauerMinuten.toDouble(),
              min: 5,
              max: 30,
              divisions: 5,
              activeColor: Colors.amber,
              label: '$_dauerMinuten Min',
              onChanged: (val) {
                setState(() {
                  _dauerMinuten = val.round();
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Deine gezogenen Übungen (Tippe für Details):', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.uebungen.length,
                itemBuilder: (context, index) {
                  final uebung = widget.uebungen[index];
                  return Card(
                    child: ListTile(
                      onTap: () => showUebungDetailDialog(context, uebung),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          uebung.imagePath,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fitness_center, color: Colors.amber),
                        ),
                      ),
                      title: Text(uebung.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${uebung.reps} Wiederholungen'),
                      trailing: const Icon(Icons.info_outline, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.vertical: 16,
              ),
              child: const Text('AMRAP Starten', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AmrapWorkoutScreen(
                      uebungen: widget.uebungen,
                      dauerMinuten: _dauerMinuten,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

/// AMRAP Workout Screen
class AmrapWorkoutScreen extends StatefulWidget {
  final List<Uebung> uebungen;
  final int dauerMinuten;

  const AmrapWorkoutScreen({super.key, required this.uebungen, required this.dauerMinuten});

  @override
  State<AmrapWorkoutScreen> createState() => _AmrapWorkoutScreenState();
}

class _AmrapWorkoutScreenState extends State<AmrapWorkoutScreen> {
  late int _remainingSeconds;
  Timer? _timer;
  int _rundenZaehler = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.dauerMinuten * 60;
    WakelockPlus.enable();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _workoutBeenden();
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer?.cancel();
      } else {
        _startTimer();
      }
    });
  }

  void _workoutBeenden() {
    globalAbgeschlosseneWorkouts++;
    globalGesamtTrainingsminuten += widget.dauerMinuten;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('AMRAP Beendet! 🎉'),
        content: Text('Hervorragend! Du hast in ${widget.dauerMinuten} Minuten insg. $_rundenZaehler Runden geschafft.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AMRAP Workout'),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Verbleibend', style: TextStyle(color: Colors.grey)),
                        Text(_formatTime(_remainingSeconds),
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Runden', style: TextStyle(color: Colors.grey)),
                        Text('$_rundenZaehler',
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Runde abschließen (+1)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() {
                  _rundenZaehler++;
                });
              },
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Zirkel-Übungen (Tippe für Details):', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.uebungen.length,
                itemBuilder: (context, index) {
                  final uebung = widget.uebungen[index];
                  return Card(
                    child: ListTile(
                      onTap: () => showUebungDetailDialog(context, uebung),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          uebung.imagePath,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fitness_center, color: Colors.amber),
                        ),
                      ),
                      title: Text(uebung.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${uebung.reps} Wiederholungen'),
                      trailing: const Icon(Icons.info_outline, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// EMOM Workout Screen (30 Minuten Dauer)
class EmomWorkoutScreen extends StatefulWidget {
  final List<Uebung> uebungen;
  const EmomWorkoutScreen({super.key, required this.uebungen});

  @override
  State<EmomWorkoutScreen> createState() => _EmomWorkoutScreenState();
}

class _EmomWorkoutScreenState extends State<EmomWorkoutScreen> {
  static const int gesamtMinuten = 30;
  int _gesamteSekunden = gesamtMinuten * 60;
  int _sekundeImIntervall = 60;
  int _aktuellerSatz = 1; // 1 bis 30
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gesamteSekunden > 0) {
        setState(() {
          _gesamteSekunden--;
          _sekundeImIntervall--;
          if (_sekundeImIntervall == 0 && _gesamteSekunden > 0) {
            _sekundeImIntervall = 60;
            _aktuellerSatz++;
          }
        });
      } else {
        _timer?.cancel();
        _workoutBeenden();
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer?.cancel();
      } else {
        _startTimer();
      }
    });
  }

  void _workoutBeenden() {
    globalAbgeschlosseneWorkouts++;
    globalGesamtTrainingsminuten += gesamtMinuten;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('EMOM Beendet! 🔥'),
        content: const Text('Glückwunsch! Du hast die vollen 30 Minuten durchgezogen.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }

  Uebung get _aktuelleUebung {
    int index = (_aktuellerSatz - 1) % widget.uebungen.length;
    return widget.uebungen[index];
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final uebung = _aktuelleUebung;

    return Scaffold(
      appBar: AppBar(
        title: Text('EMOM - Satz $_aktuellerSatz von $gesamtMinuten'),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Gesamtziel: ${_formatTime(_gesamteSekunden)}', style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 12),
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Satz-Timer (1 Min)', style: TextStyle(color: Colors.grey)),
                    Text(
                      '$_sekundeImIntervall',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: _sekundeImIntervall <= 10 ? Colors.redAccent : Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () => showUebungDetailDialog(context, uebung),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Aktuelle Übung:', style: TextStyle(color: Colors.grey[400])),
                        const SizedBox(height: 8),
                        Text(
                          uebung.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            uebung.imagePath,
                            height: 140,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.fitness_center, size: 80, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ziel: ${uebung.reps} Wiederholungen',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('(Tippe auf das Feld für Erklärung)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mediathek & Rep-Verwaltung
class MediathekScreen extends StatefulWidget {
  const MediathekScreen({super.key});

  @override
  State<MediathekScreen> createState() => _MediathekScreenState();
}

class _MediathekScreenState extends State<MediathekScreen> {
  Future<void> _saveReps(Uebung uebung) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reps_${uebung.id}', uebung.reps);
  }

  void _bearbeiteRepsDialog(Uebung uebung) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(uebung.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 36, color: Colors.amber),
                        onPressed: () {
                          if (uebung.reps > 1) {
                            setModalState(() => uebung.reps--);
                            setState(() {});
                            _saveReps(uebung);
                          }
                        },
                      ),
                      const SizedBox(width: 24),
                      Text('${uebung.reps} Reps', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 36, color: Colors.amber),
                        onPressed: () {
                          setModalState(() => uebung.reps++);
                          setState(() {});
                          _saveReps(uebung);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Speichern & Schließen'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Übungs-Mediathek')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: globaleUebungen.length,
        itemBuilder: (context, index) {
          final uebung = globaleUebungen[index];
          return Card(
            child: ListTile(
              onTap: () => showUebungDetailDialog(context, uebung),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  uebung.imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fitness_center, color: Colors.amber),
                ),
              ),
              title: Text(uebung.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Standard: ${uebung.reps} Wiederholungen'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.amber),
                onPressed: () => _bearbeiteRepsDialog(uebung),
              ),
            ),
          );
        },
      ),
    );
  }
}
