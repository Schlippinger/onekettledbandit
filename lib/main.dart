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

// Datenstruktur für die Übungen
class Uebung {
  final String name;
  final String beschreibung;
  final String muskeln;
  final String kategorie;
  final String bildUrl;

  Uebung({
    required this.name,
    required this.beschreibung,
    required this.muskeln,
    required this.kategorie,
    required this.bildUrl,
  });
}

// Globale Listen und Statistiken
final List<Uebung> alleUebungen = [
  Uebung(
      name: 'Goblet Squat',
      beschreibung: 'Kettlebell vor der Brust halten. Füße etwa schulterbreit. Gesäß nach hinten unten führen.',
      muskeln: 'Oberschenkel, Gesäß, Core',
      kategorie: 'Unterkörper',
      bildUrl: 'assets/assets/gobletsquat.png'),
  Uebung(
      name: 'Single-Leg Deadlift',
      beschreibung: 'Auf einem Bein stehen, das andere nach hinten anheben. Hüfte nach hinten schieben.',
      muskeln: 'Gesäß, hintere Oberschenkel, Rücken',
      kategorie: 'Unterkörper',
      bildUrl: 'https://picsum.photos/id/21/400/600'), // Platzhalter
  Uebung(
      name: 'Bulgarian Split Squat',
      beschreibung: 'Hinteren Fuß auf Bank ablegen. Kettlebell vor der Brust halten. Kontrolliert absenken.',
      muskeln: 'Beine, Gesäß, Gleichgewicht',
      kategorie: 'Unterkörper',
      bildUrl: 'assets/assets/bulgariansplitsquad.png'),
  Uebung(
      name: 'Reverse Lunge',
      beschreibung: 'Kettlebell vor der Brust halten. Großen Schritt nach hinten machen.',
      muskeln: 'Beine, Gesäß, Core',
      kategorie: 'Unterkörper',
      bildUrl: 'https://picsum.photos/id/23/400/600'), // Platzhalter
  Uebung(
      name: 'Sumo Squat (3s Stop)',
      beschreibung: 'Breiter Stand, Fußspitzen nach außen. Tief absenken, 3 Sekunden halten.',
      muskeln: 'Innenschenkel, Gesäß, Beine',
      kategorie: 'Unterkörper',
      bildUrl: 'https://picsum.photos/id/24/400/600'), // Platzhalter
  Uebung(
      name: 'Einarmiges Rudern',
      beschreibung: 'Hand auf Knie abstützen. Kettlebell zur Hüfte ziehen.',
      muskeln: 'Oberer Rücken, Latissimus, Bizeps',
      kategorie: 'Rücken',
      bildUrl: 'assets/assets/einarmigesrudern.png'),
  Uebung(
      name: 'Staggered Row',
      beschreibung: 'Ausfallschritt, auf Oberschenkel abstützen und einarmig zur Hüfte rudern.',
      muskeln: 'Rücken, Core',
      kategorie: 'Rücken',
      bildUrl: 'https://picsum.photos/id/26/400/600'), // Platzhalter
  Uebung(
      name: 'High Pull',
      beschreibung: 'Aus der Hüfte Schwung holen. Ellbogen führt nach oben/außen.',
      muskeln: 'Rücken, Schultern, Hüfte',
      kategorie: 'Rücken',
      bildUrl: 'assets/assets/highpull.png'),
  Uebung(
      name: 'Suitcase Carry',
      beschreibung: 'Kettlebell einseitig wie einen Koffer tragen. Aufrecht gehen.',
      muskeln: 'Rücken, Griffkraft, seitlicher Core',
      kategorie: 'Rücken',
      bildUrl: 'https://picsum.photos/id/28/400/600'), // Platzhalter
  Uebung(
      name: 'Overhead Press',
      beschreibung: 'Aus der Rack-Position über den Kopf drücken.',
      muskeln: 'Schultern, Trizeps, Core',
      kategorie: 'Oberkörper',
      bildUrl: 'assets/assets/overheadpress.png'),
  Uebung(
      name: 'Push Press',
      beschreibung: 'Kettlebell einarmig in Rack-Position halten, durch leichten Beinschwung explosiv über den Kopf drücken.',
      muskeln: 'Schultern, Trizeps, Beine, Core',
      kategorie: 'Oberkörper',
      bildUrl: 'https://picsum.photos/id/30/400/600'), // Platzhalter
  Uebung(
      name: 'Floor Press',
      beschreibung: 'Auf dem Rücken liegen. Von der Brust nach oben drücken.',
      muskeln: 'Brust, Trizeps, Schultern',
      kategorie: 'Oberkörper',
      bildUrl: 'assets/assets/floorpress.png'),
  Uebung(
      name: 'Quarter Get-Up',
      beschreibung: 'Rückenlage. Kettlebell nach oben strecken. Aufrichten bis zum Ellbogen.',
      muskeln: 'Schulterstabilität, Core',
      kategorie: 'Oberkörper',
      bildUrl: 'https://picsum.photos/id/32/400/600'), // Platzhalter
  Uebung(
      name: 'Russian Twist',
      beschreibung: 'Sitzen, leicht zurücklehnen. Kettlebell von Seite zu Seite bewegen.',
      muskeln: 'Schräge Bauchmuskeln',
      kategorie: 'Core',
      bildUrl: 'https://picsum.photos/id/33/400/600'), // Platzhalter
  Uebung(
      name: 'Kettlebell Sit-Up',
      beschreibung: 'Rückenlage. Kettlebell vor der Brust halten. Aufrichten.',
      muskeln: 'Gerade Bauchmuskulatur',
      kategorie: 'Core',
      bildUrl: 'assets/assets/kettlebellsitup.png'),
  Uebung(
      name: 'Plank Pull-Through',
      beschreibung: 'Unterarmstütz. Kettlebell unter dem Körper auf die andere Seite ziehen.',
      muskeln: 'Gesamte Bauchmuskulatur, Schulterstabilität',
      kategorie: 'Core',
      bildUrl: 'assets/assets/plankpullthrough.png'),
  Uebung(
      name: 'Dead Bug',
      beschreibung: 'Rückenlage. Kettlebell mit gestreckten Armen halten. Beine wechselnd strecken.',
      muskeln: 'Tiefe Bauchmuskulatur',
      kategorie: 'Core',
      bildUrl: 'assets/assets/deadbug.png'),
  Uebung(
      name: 'Kettlebell Swing',
      beschreibung: 'Aus der Hüfte schwingen. Kugel fliegt bis auf Brusthöhe.',
      muskeln: 'Gesäß, Rücken, Core, Kondition',
      kategorie: 'Ganzkörper',
      bildUrl: 'assets/assets/kettlebellswing.png'),
  Uebung(
      name: 'Clean',
      beschreibung: 'Aus dem Schwung eng am Körper in die Rack-Position führen.',
      muskeln: 'Ganzkörper, Koordination',
      kategorie: 'Ganzkörper',
      bildUrl: 'assets/assets/clean.png'),
  Uebung(
      name: 'Turkish Get-Up',
      beschreibung: 'Vom Liegen mit ausgestrecktem Arm schrittweise zum Stand aufstehen.',
      muskeln: 'Gesamter Körper, Stabilität, Mobilität',
      kategorie: 'Ganzkörper',
      bildUrl: 'https://picsum.photos/id/39/400/600'), // Platzhalter
];

int statistikGesamtMinuten = 0;
int statistikAnzahlWorkouts = 0;
Map<String, int> uebungsZaehler = {};

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
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Slot Machine'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Mediathek'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Statistik'),
        ],
      ),
    );
  }
}

class SlotMachinePage extends StatefulWidget {
  @override
  _SlotMachinePageState createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends State<SlotMachinePage> {
  List<Uebung?> _aktuellesWorkout = [null, null, null, null, null];

  void _spinSlotMachine() {
    final random = Random();
    setState(() {
      List<Uebung> gezogeneUebungen = [
        alleUebungen[random.nextInt(5)],       // Unterkörper
        alleUebungen[5 + random.nextInt(4)],   // Rücken
        alleUebungen[9 + random.nextInt(4)],   // Oberkörper
        alleUebungen[13 + random.nextInt(4)],  // Core
        alleUebungen[17 + random.nextInt(3)],  // Ganzkörper
      ];

      gezogeneUebungen.shuffle(random);
      _aktuellesWorkout = gezogeneUebungen;
    });
  }

  void _startWorkout() {
    if (_aktuellesWorkout.contains(null)) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AktiverWorkoutBildschirm(
            aktuellesWorkout: _aktuellesWorkout.cast<Uebung>()),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🎰 One-kettled bandit'), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Dein heutiger Trainingsplan:', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 15),
            Card(
              color: Colors.grey[900],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: _aktuellesWorkout.asMap().entries.map((entry) {
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Text('${entry.key + 1}',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                      title: Text(entry.value?.name ?? '?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: entry.value != null 
                          ? Text(entry.value!.kategorie, style: TextStyle(color: Colors.grey, fontSize: 13))
                          : null,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _spinSlotMachine,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
              child: Text('SPIN! 🎰', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            if (!_aktuellesWorkout.contains(null))
              ElevatedButton(
                onPressed: _startWorkout,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                child: Text('WORKOUT STARTEN ▶️', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

class AktiverWorkoutBildschirm extends StatefulWidget {
  final List<Uebung> aktuellesWorkout;

  AktiverWorkoutBildschirm({required this.aktuellesWorkout});

  @override
  _AktiverWorkoutBildschirmState createState() => _AktiverWorkoutBildschirmState();
}

class _AktiverWorkoutBildschirmState extends State<AktiverWorkoutBildschirm> {
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

          String uebungsName = widget.aktuellesWorkout[_aktuelleUebungIndex].name;
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
        content: Text('Du hast das 30-minütige Kettlebell-Workout beendet!'),
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
            height: MediaQuery.of(context).size.height * 0.60,
            child: uebung.bildUrl.startsWith('http')
                ? Image.network(
                    uebung.bildUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                        color: Colors.grey[900],
                        child: Icon(Icons.fitness_center, size: 80, color: Colors.orange)),
                  )
                : Image.asset(
                    uebung.bildUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                        color: Colors.grey[900],
                        child: Icon(Icons.fitness_center, size: 80, color: Colors.orange)),
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent, Colors.black],
                stops: [0.0, 0.4, 0.85],
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
                      Text('ÜBUNG ${_aktuelleUebungIndex + 1} VON 5',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      Text('Gesamt: $_abgelaufeneGesamtMinuten/30 Min', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(uebung.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      SizedBox(height: 5),
                      Text('${uebung.kategorie} • Fokus: ${uebung.muskeln}',
                          style: TextStyle(fontSize: 14, color: Colors.orange, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                      SizedBox(height: 8),
                      Text(uebung.beschreibung, style: TextStyle(fontSize: 14, color: Colors.grey[300]), textAlign: TextAlign.center),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Abbrechen 🛑', style: TextStyle(color: Colors.red, fontSize: 16))),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                      value: _verbleibendeSekunden / 60,
                                      strokeWidth: 6,
                                      valueColor: AlwaysStoppedAnimation(Colors.orange))),
                              Text('0:${_verbleibendeSekunden.toString().padLeft(2, '0')}',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

class MediathekPage extends StatefulWidget {
  @override
  _MediathekPageState createState() => _MediathekPageState();
}

class _MediathekPageState extends State<MediathekPage> {
  String _ausgewaehlterFilter = 'Alle';
  String _ausgewaehlteSortierung = 'Alphabetisch (A-Z)';

  final List<String> _kategorien = ['Alle', 'Unterkörper', 'Rücken', 'Oberkörper', 'Core', 'Ganzkörper'];
  final List<String> _sortierOptionen = ['Alphabetisch (A-Z)', 'Nach Muskelgruppe'];

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
      appBar: AppBar(title: Text('📚 Übungs-Mediathek'), backgroundColor: Colors.black),
      body: Column(
        children: [
          Container(
            color: Colors.grey[950],
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _ausgewaehlterFilter,
                    decoration: InputDecoration(labelText: 'Filter', labelStyle: TextStyle(color: Colors.orange)),
                    items: _kategorien
                        .map((kat) => DropdownMenuItem(value: kat, child: Text(kat, style: TextStyle(fontSize: 14))))
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
                    decoration: InputDecoration(labelText: 'Sortieren', labelStyle: TextStyle(color: Colors.orange)),
                    items: _sortierOptionen
                        .map((opt) => DropdownMenuItem(value: opt, child: Text(opt, style: TextStyle(fontSize: 14))))
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
            child: gefilterte
