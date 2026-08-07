import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(KettlebellApp());

class KettlebellApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HauptNavigationsPage(),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELL & DATEN
// -----------------------------------------------------------------------------

class Uebung {
  final String name;
  final String beschreibung;
  final String muskeln;
  final String kategorie;
  final String bildUrl;
  int zielWiederholungen; // Editierbare Ziel-Wiederholungszahl

  Uebung({
    required this.name,
    required this.beschreibung,
    required this.muskeln,
    required this.kategorie,
    required this.bildUrl,
    this.zielWiederholungen = 10,
  });
}

// Globale Übungsliste (Pfad-Tippfehler beim Single-Leg Deadlift korrigiert)
final List<Uebung> alleUebungen = [
  Uebung(
      name: 'Goblet Squat',
      beschreibung: 'Kettlebell vor der Brust halten. Füße etwa schulterbreit. Gesäß nach hinten unten führen.',
      muskeln: 'Oberschenkel, Gesäß, Core',
      kategorie: 'Unterkörper',
      bildUrl: 'assets/gobletsquat.png',
      zielWiederholungen: 10),
  Uebung(
      name: 'Single-Leg Deadlift',
      beschreibung: 'Auf einem Bein stehen, das andere nach hinten anheben. Hüfte nach hinten schieben.',
      muskeln: 'Gesäß, hintere Oberschenkel, Rücken',
      kategorie: 'Unterkörper',
      bildUrl: 'assets/singlelegdeadlift.png',
      zielWiederholungen: 8),
  Uebung(
      name: 'Bulgarian Split Squat',
      beschreibung: 'Hinteren Fuß auf Bank ablegen. Kettlebell vor der Brust halten. Kontrolliert absenken.',
      muskeln: 'Beine, Gesäß, Gleichgewicht',
      kategorie: 'Unterkörper',
      bildUrl: 'assets/bulgariansplitsquat.png',
      zielWiederholungen: 8),
  Uebung(
      name: 'Reverse Lunge',
      beschreibung: 'Kettlebell vor der Brust halten. Großen Schritt nach hinten machen.',
      muskeln: 'Beine, Gesäß, Core',
      kategorie: 'Unterkörper',
      bildUrl: 'assets/reverselunge.png',
      zielWiederholungen: 12),
  Uebung(
      name: 'Sumo Squat (3s Stop)',
      beschreibung: 'Breiter Stand, Fußspitzen nach außen. Tief absenken, 3 Sekunden halten.',
      muskeln: 'Innenschenkel, Gesäß, Beine',
      kategorie: 'Unterkörper',
      bildUrl: 'assets/sumosquat.png',
      zielWiederholungen: 8),
  Uebung(
      name: 'Einarmiges Rudern',
      beschreibung: 'Hand auf Knie abstützen. Kettlebell zur Hüfte ziehen.',
      muskeln: 'Oberer Rücken, Latissimus, Bizeps',
      kategorie: 'Rücken',
      bildUrl: 'assets/einarmigesrudern.png',
      zielWiederholungen: 10),
  Uebung(
      name: 'Staggered Row',
      beschreibung: 'Ausfallschritt, auf Oberschenkel abstützen und einarmig zur Hüfte rudern.',
      muskeln: 'Rücken, Core',
      kategorie: 'Rücken',
      bildUrl: 'assets/staggeredrow.png',
      zielWiederholungen: 10),
  Uebung(
      name: 'High Pull',
      beschreibung: 'Aus der Hüfte Schwung holen. Ellbogen führt nach oben/außen.',
      muskeln: 'Rücken, Schultern, Hüfte',
      kategorie: 'Rücken',
      bildUrl: 'assets/highpull.png',
      zielWiederholungen: 12),
  Uebung(
      name: 'Suitcase Carry',
      beschreibung: 'Kettlebell einseitig wie einen Koffer tragen. Aufrecht gehen.',
      muskeln: 'Rücken, Griffkraft, seitlicher Core',
      kategorie: 'Rücken',
      bildUrl: 'assets/suitcasecarry.png',
      zielWiederholungen: 15),
  Uebung(
      name: 'Overhead Press',
      beschreibung: 'Aus der Rack-Position über den Kopf drücken.',
      muskeln: 'Schultern, Trizeps, Core',
      kategorie: 'Oberkörper',
      bildUrl: 'assets/overheadpress.png',
      zielWiederholungen: 8),
  Uebung(
      name: 'Push Press',
      beschreibung: 'Kleine Kniebeuge, mit Beinschwung über Kopf drücken.',
      muskeln: 'Schultern, Trizeps, Beine, Core',
      kategorie: 'Oberkörper',
      bildUrl: 'assets/pushpress.png',
      zielWiederholungen: 10),
  Uebung(
      name: 'Floor Press',
      beschreibung: 'Auf dem Rücken liegen. Von der Brust nach oben drücken.',
      muskeln: 'Brust, Trizeps, Schultern',
      kategorie: 'Oberkörper',
      bildUrl: 'assets/floorpress.png',
      zielWiederholungen: 10),
  Uebung(
      name: 'Quarter Get-Up',
      beschreibung: 'Rückenlage. Kettlebell nach oben strecken. Aufrichten bis zum Ellbogen.',
      muskeln: 'Schulterstabilität, Core',
      kategorie: 'Oberkörper',
      bildUrl: 'assets/quartergetup.png',
      zielWiederholungen: 5),
  Uebung(
      name: 'Russian Twist',
      beschreibung: 'Sitzen, leicht zurücklehnen. Kettlebell von Seite zu Seite bewegen.',
      muskeln: 'Schräge Bauchmuskeln',
      kategorie: 'Core',
      bildUrl: 'assets/russiantwist.png',
      zielWiederholungen: 20),
  Uebung(
      name: 'Kettlebell Sit-Up',
      beschreibung: 'Rückenlage. Kettlebell vor der Brust halten. Aufrichten.',
      muskeln: 'Gerade Bauchmuskulatur',
      kategorie: 'Core',
      bildUrl: 'assets/kettlebellsitup.png',
      zielWiederholungen: 12),
  Uebung(
      name: 'Plank Pull-Through',
      beschreibung: 'Unterarmstütz. Kettlebell unter dem Körper auf die andere Seite ziehen.',
      muskeln: 'Gesamte Bauchmuskulatur, Schulterstabilität',
      kategorie: 'Core',
      bildUrl: 'assets/plankpullthrough.png',
      zielWiederholungen: 12),
  Uebung(
      name: 'Dead Bug',
      beschreibung: 'Rückenlage. Kettlebell mit gestreckten Armen halten. Beine wechselnd strecken.',
      muskeln: 'Tiefe Bauchmuskulatur',
      kategorie: 'Core',
      bildUrl: 'assets/deadbug.png',
      zielWiederholungen: 12),
  Uebung(
      name: 'Kettlebell Swing',
      beschreibung: 'Aus der Hüfte schwingen. Kugel fliegt bis auf Brusthöhe.',
      muskeln: 'Gesäß, Rücken, Core, Kondition',
      kategorie: 'Ganzkörper',
      bildUrl: 'assets/kettlebellswing.png',
      zielWiederholungen: 15),
  Uebung(
      name: 'Clean',
      beschreibung: 'Aus dem Schwung eng am Körper in die Rack-Position führen.',
      muskeln: 'Ganzkörper, Koordination',
      kategorie: 'Ganzkörper',
      bildUrl: 'assets/clean.png',
      zielWiederholungen: 10),
  Uebung(
      name: 'Turkish Get-Up',
      beschreibung: 'Vom Liegen mit ausgestrecktem Arm schrittweise zum Stand aufstehen.',
      muskeln: 'Gesamter Körper, Stabilität, Mobilität',
      kategorie: 'Ganzkörper',
      bildUrl: 'assets/turkishgetup.png',
      zielWiederholungen: 3),
];

int statistikGesamtMinuten = 0;
int statistikAnzahlWorkouts = 0;
Map<String, int> uebungsZaehler = {};

enum WorkoutModus { emom, amrap }

// -----------------------------------------------------------------------------
// NAVIGATION
// -----------------------------------------------------------------------------

class HauptNavigationsPage extends StatefulWidget {
  @override
  _HauptNavigationsPageState createState() => _HauptNavigationsPageState();
}

class _HauptNavigationsPageState extends State<HauptNavigationsPage> {
  int _aktuellerIndex = 0;

  final List<Widget> _seiten = [
    SlotMachinePage(),
    MediathekPage(),
    StatistikPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _seiten[_aktuellerIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktuellerIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _aktuellerIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.casino), label: 'Slot Machine'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Mediathek'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Statistik'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SLOT MACHINE PAGE
// -----------------------------------------------------------------------------

class SlotMachinePage extends StatefulWidget {
  @override
  _SlotMachinePageState createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends State<SlotMachinePage> {
  List<Uebung?> _aktuellesWorkout = [null, null, null, null, null];
  WorkoutModus _ausgewaehlterModus = WorkoutModus.emom;
  int _amrapTimeCapMinuten = 15;

  void _spinSlotMachine() {
    final random = Random();
    setState(() {
      _aktuellesWorkout = [
        alleUebungen[random.nextInt(5)],
        alleUebungen[5 + random.nextInt(4)],
        alleUebungen[9 + random.nextInt(4)],
        alleUebungen[13 + random.nextInt(4)],
        alleUebungen[17 + random.nextInt(3)],
      ];
    });
  }

  void _startWorkout() {
    if (_aktuellesWorkout.contains(null)) return;

    Widget targetPage = _ausgewaehlterModus == WorkoutModus.emom
        ? EmomWorkoutBildschirm(
            aktuellesWorkout: _aktuellesWorkout.cast<Uebung>())
        : AmrapWorkoutBildschirm(
            aktuellesWorkout: _aktuellesWorkout.cast<Uebung>(),
            timeCapMinuten: _amrapTimeCapMinuten,
          );

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => targetPage,
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hatWorkout = !_aktuellesWorkout.contains(null);

    return Scaffold(
      appBar: AppBar(
          title: Text('🎰 One-kettled bandit'), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Dein heutiger Trainingsplan:',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 15),
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: _aktuellesWorkout.asMap().entries.map((entry) {
                    Uebung? uebung = entry.value;
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Text('${entry.key + 1}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      title: Text(uebung?.name ?? '?',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: uebung != null
                          ? Text('${uebung.zielWiederholungen} Reps',
                              style: TextStyle(color: Colors.orange))
                          : null,
                      trailing: uebung != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      if (uebung.zielWiederholungen > 1) {
                                        uebung.zielWiederholungen--;
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, size: 18),
                                  onPressed: () {
                                    setState(() {
                                      uebung.zielWiederholungen++;
                                    });
                                  },
                                ),
                              ],
                            )
                          : null,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _spinSlotMachine,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
              child: Text('SPIN! 🎰',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            if (hatWorkout) ...[
              SizedBox(height: 25),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              Text('Trainingsmodus wählen:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              SegmentedButton<WorkoutModus>(
                segments: const [
                  ButtonSegment(
                      value: WorkoutModus.emom,
                      label: Text('⏱️ EMOM (30 Min)'),
                      tooltip: 'Every Minute On the Minute'),
                  ButtonSegment(
                      value: WorkoutModus.amrap,
                      label: Text('🔥 AMRAP'),
                      tooltip: 'As Many Rounds As Possible'),
                ],
                selected: {_ausgewaehlterModus},
                onSelectionChanged: (Set<WorkoutModus> newSelection) {
                  setState(() {
                    _ausgewaehlterModus = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.orange;
                    }
                    return Colors.grey[900];
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.black;
                    }
                    return Colors.white;
                  }),
                ),
              ),
              if (_ausgewaehlterModus == WorkoutModus.amrap) ...[
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time-Cap: $_amrapTimeCapMinuten Min',
                        style: TextStyle(color: Colors.grey)),
                    Slider(
                      value: _amrapTimeCapMinuten.toDouble(),
                      min: 5,
                      max: 30,
                      divisions: 5,
                      activeColor: Colors.orange,
                      label: '$_amrapTimeCapMinuten Min',
                      onChanged: (val) {
                        setState(() {
                          _amrapTimeCapMinuten = val.round();
                        });
                      },
                    ),
                  ],
                ),
              ],
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _startWorkout,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
                child: Text('WORKOUT STARTEN ▶️',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// EMOM WORKOUT SCREEN
// -----------------------------------------------------------------------------

class EmomWorkoutBildschirm extends StatefulWidget {
  final List<Uebung> aktuellesWorkout;

  EmomWorkoutBildschirm({required this.aktuellesWorkout});

  @override
  _EmomWorkoutBildschirmState createState() => _EmomWorkoutBildschirmState();
}

class _EmomWorkoutBildschirmState extends State<EmomWorkoutBildschirm> {
  int _aktuelleUebungIndex = 0;
  int _verbleibendeSekunden = 60;
  int _abgelaufeneGesamtMinuten = 0;
  Timer? _uebungsTimer;

  @override
  void initState() {
    super.initState();
    _starteTimer();
  }

  void _starteTimer() {
    _uebungsTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_verbleibendeSekunden > 1) {
          _verbleibendeSekunden--;
        } else {
          _verbleibendeSekunden = 60;
          _abgelaufeneGesamtMinuten++;
          statistikGesamtMinuten++;

          String uebungsName =
              widget.aktuellesWorkout[_aktuelleUebungIndex].name;
          uebungsZaehler[uebungsName] = (uebungsZaehler[uebungsName] ?? 0) + 1;

          if (_abgelaufeneGesamtMinuten >= 30) {
            _uebungsTimer?.cancel();
            statistikAnzahlWorkouts++;
            _zeigeWorkoutBeendetDialog();
          } else {
            _aktuelleUebungIndex = (_aktuelleUebungIndex + 1) % 5;
          }
        }
      });
    });
  }

  void _zeigeWorkoutBeendetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🎉 Gratulation!'),
        content: Text('Du hast das 30-minütige EMOM-Workout beendet!'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Super!'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _uebungsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Uebung uebung = widget.aktuellesWorkout[_aktuelleUebungIndex];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Image.asset(
              uebung.bildUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                  color: Colors.grey[900],
                  child: Icon(Icons.fitness_center,
                      size: 80, color: Colors.orange)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                  Colors.black
                ],
                stops: [0.0, 0.35, 0.8],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('EMOM • ÜBUNG ${_aktuelleUebungIndex + 1} VON 5',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                      Text('Gesamt: $_abgelaufeneGesamtMinuten/30 Min',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(uebung.name,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      SizedBox(height: 5),
                      Chip(
                        backgroundColor: Colors.orange,
                        label: Text(
                          '${uebung.zielWiederholungen} Wiederholungen',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(uebung.beschreibung,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[300]),
                          textAlign: TextAlign.center),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Abbrechen 🛑',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16))),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                      value: _verbleibendeSekunden / 60,
                                      strokeWidth: 6,
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.orange))),
                              Text(
                                  '0:${_verbleibendeSekunden.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// AMRAP WORKOUT SCREEN
// -----------------------------------------------------------------------------

class AmrapWorkoutBildschirm extends StatefulWidget {
  final List<Uebung> aktuellesWorkout;
  final int timeCapMinuten;

  AmrapWorkoutBildschirm(
      {required this.aktuellesWorkout, required this.timeCapMinuten});

  @override
  _AmrapWorkoutBildschirmState createState() => _AmrapWorkoutBildschirmState();
}

class _AmrapWorkoutBildschirmState extends State<AmrapWorkoutBildschirm> {
  int _aktuelleUebungIndex = 0;
  int _absolvierteRunden = 0;
  late int _verbleibendeSekunden;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _verbleibendeSekunden = widget.timeCapMinuten * 60;
    _starteTimer();
  }

  void _starteTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_verbleibendeSekunden > 1) {
          _verbleibendeSekunden--;
        } else {
          _countdownTimer?.cancel();
          _beendeWorkout();
        }
      });
    });
  }

  void _naechsteUebung() {
    setState(() {
      String uebungsName = widget.aktuellesWorkout[_aktuelleUebungIndex].name;
      uebungsZaehler[uebungsName] = (uebungsZaehler[uebungsName] ?? 0) + 1;

      if (_aktuelleUebungIndex == widget.aktuellesWorkout.length - 1) {
        _absolvierteRunden++;
        _aktuelleUebungIndex = 0;
      } else {
        _aktuelleUebungIndex++;
      }
    });
  }

  void _beendeWorkout() {
    _countdownTimer?.cancel();
    int trainierteMinuten =
        widget.timeCapMinuten - (_verbleibendeSekunden ~/ 60);
    statistikGesamtMinuten += trainierteMinuten;
    statistikAnzahlWorkouts++;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🔥 AMRAP Beendet!'),
        content: Text(
            'Starke Leistung!\n\nGeschaffte Runden: $_absolvierteRunden\nTrainierte Zeit: $trainierteMinuten Min'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Fertig'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Uebung uebung = widget.aktuellesWorkout[_aktuelleUebungIndex];
    int minuten = _verbleibendeSekunden ~/ 60;
    int sekunden = _verbleibendeSekunden % 60;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Image.asset(
              uebung.bildUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                  color: Colors.grey[900],
                  child: Icon(Icons.fitness_center,
                      size: 80, color: Colors.orange)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                  Colors.black
                ],
                stops: [0.0, 0.35, 0.8],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RUNDE ${_absolvierteRunden + 1}',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          '⏱️ ${minuten.toString().padLeft(2, '0')}:${sekunden.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Übung ${_aktuelleUebungIndex + 1} von 5',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 5),
                      Text(uebung.name,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      SizedBox(height: 10),
                      Chip(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        label: Text(
                          '${uebung.zielWiederholungen} Wiederholungen',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: _naechsteUebung,
                        icon: Icon(Icons.check_circle, color: Colors.black),
                        label: Text('ÜBUNG ERLEDIGT! ➔',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextButton(
                        onPressed: _beendeWorkout,
                        child: Text('Workout jetzt beenden 🛑',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MEDIATHEK PAGE
// -----------------------------------------------------------------------------

class MediathekPage extends StatefulWidget {
  @override
  _MediathekPageState createState() => _MediathekPageState();
}

class _MediathekPageState extends State<MediathekPage> {
  String _ausgewaehlterFilter = 'Alle';
  String _ausgewaehlteSortierung = 'Alphabetisch (A-Z)';

  final List<String> _kategorien = [
    'Alle',
    'Unterkörper',
    'Rücken',
    'Oberkörper',
    'Core',
    'Ganzkörper'
  ];
  final List<String> _sortierOptionen = [
    'Alphabetisch (A-Z)',
    'Nach Muskelgruppe'
  ];

  @override
  Widget build(BuildContext context) {
    List<Uebung> gefilterteListe = alleUebungen.where((uebung) {
      if (_ausgewaehlterFilter == 'Alle') return true;
      return uebung.kategorie == _ausgewaehlterFilter;
    }).toList();

    if (_ausgewaehlteSortierung == 'Alphabetisch (A-Z)') {
      gefilterteListe.sort((a, b) => a.name.compareTo(b.name));
    } else if (_ausgewaehlteSortierung == 'Nach Muskelgruppe') {
      gefilterteListe.sort((a, b) => a.kategorie.compareTo(b.kategorie));
    }

    return Scaffold(
      appBar: AppBar(
          title: Text('📚 Übungs-Mediathek'), backgroundColor: Colors.black),
      body: Column(
        children: [
          Container(
            color: Colors.grey[950],
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _ausgewaehlterFilter,
                    decoration: InputDecoration(
                        labelText: 'Filter',
                        labelStyle: TextStyle(color: Colors.orange)),
                    items: _kategorien
                        .map((kat) => DropdownMenuItem(
                            value: kat,
                            child: Text(kat, style: TextStyle(fontSize: 14))))
                        .toList(),
                    onChanged: (wert) {
                      setState(() {
                        _ausgewaehlterFilter = wert!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _ausgewaehlteSortierung,
                    decoration: InputDecoration(
                        labelText: 'Sortieren',
                        labelStyle: TextStyle(color: Colors.orange)),
                    items: _sortierOptionen
                        .map((opt) => DropdownMenuItem(
                            value: opt,
                            child: Text(opt, style: TextStyle(fontSize: 14))))
                        .toList(),
                    onChanged: (wert) {
                      setState(() {
                        _ausgewaehlteSortierung = wert!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: gefilterteListe.isEmpty
                ? Center(
                    child: Text('Keine Übungen für diesen Filter gefunden.',
                        style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: gefilterteListe.length,
                    itemBuilder: (context, index) {
                      Uebung uebung = gefilterteListe[index];
                      return Card(
                        color: Colors.grey[900],
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading:
                              Icon(Icons.fitness_center, color: Colors.orange),
                          title: Text(uebung.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${uebung.kategorie} • Standard: ${uebung.zielWiederholungen} Reps',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey),
                          onTap: () {
                            _zeigeUebungDetailsBottomSheet(context, uebung);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _zeigeUebungDetailsBottomSheet(BuildContext context, Uebung uebung) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[950],
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return FractionallySizedBox(
            heightFactor: 0.85,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      child: Image.asset(
                        uebung.bildUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: Colors.grey[900],
                          child: Icon(Icons.fitness_center,
                              size: 80, color: Colors.orange),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(uebung.name,
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                        SizedBox(height: 5),
                        Text('Kategorie: ${uebung.kategorie}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white70)),
                        Text('Fokus: ${uebung.muskeln}',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey)),
                        Divider(color: Colors.grey, height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Standard-Wiederholungen:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.remove_circle, color: Colors.orange),
                                  onPressed: () {
                                    setModalState(() {
                                      if (uebung.zielWiederholungen > 1) {
                                        uebung.zielWiederholungen--;
                                      }
                                    });
                                    setState(() {});
                                  },
                                ),
                                Text('${uebung.zielWiederholungen}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: Icon(Icons.add_circle, color: Colors.orange),
                                  onPressed: () {
                                    setModalState(() {
                                      uebung.zielWiederholungen++;
                                    });
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey, height: 25),
                        Text('Ausführung:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(uebung.beschreibung,
                            style: TextStyle(fontSize: 15, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STATISTIK PAGE
// -----------------------------------------------------------------------------

class StatistikPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('📊 Deine Erfolge'), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('$statistikGesamtMinuten',
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange)),
                          Text('Minuten trainiert',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('$statistikAnzahlWorkouts',
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                          Text('Workouts beendet',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text('Häufigkeit der Übungen:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: uebungsZaehler.isEmpty
                  ? Center(
                      child: Text(
                          'Noch keine Daten vorhanden.\nStarte ein Workout!',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center))
                  : ListView(
                      children: uebungsZaehler.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Chip(
                            backgroundColor: Colors.orange,
                            label: Text('${entry.value}x',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
