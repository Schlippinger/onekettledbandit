import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
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

  const Uebung({
    required this.name,
    required this.beschreibung,
    required this.muskeln,
    required this.kategorie,
    required this.bildUrl,
  });

  static const List<Uebung> alleUebungen = [
    // 0-4: Unterkörper (5 Übungen)
    Uebung(name: 'Goblet Squat', beschreibung: 'Kettlebell vor der Brust halten. Fuesse schulterbreit. Gesaess nach hinten absenken.', muskeln: 'Oberschenkel, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'assets/gobletsquat.png'),
    Uebung(name: 'Single-Leg Deadlift', beschreibung: 'Einbeinig stehen, Huefte nach hinten schieben, Kettlebell kontrolliert senken.', muskeln: 'Beinrueckseite, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/21/400/600'),
    Uebung(name: 'Bulgarian Split Squat', beschreibung: 'Hinterer Fuss erhöht ablegen. Kettlebell vor der Brust. Tief absenken.', muskeln: 'Beine, Balance', kategorie: 'Unterkoerper', bildUrl: 'assets/bulgariansplitsquad.png'),
    Uebung(name: 'Reverse Lunge', beschreibung: 'Aufrechter Stand. Weiten Schritt nach hinten machen. Knie fast zum Boden.', muskeln: 'Beine, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/23/400/600'),
    Uebung(name: 'Sumo Squat', beschreibung: 'Breiter Stand, Zehen nach aussen. 3 Sek. am tiefsten Punkt halten.', muskeln: 'Adduktoren, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/24/400/600'),
     
    // 5-8: Rücken (4 Übungen)
    Uebung(name: 'Einarmiges Rudern', beschreibung: 'Vorgebeugt, einarmig die Kugel zur Huefte ziehen. Ellbogen eng am Körper.', muskeln: 'Ruecken, Bizeps', kategorie: 'Ruecken', bildUrl: 'assets/einarmigesrudern.png'),
    Uebung(name: 'Staggered Row', beschreibung: 'Versetzter Stand. Gewicht auf vorderem Bein. Einarmig rudern.', muskeln: 'Ruecken, Latissimus', kategorie: 'Ruecken', bildUrl: 'https://picsum.photos/id/26/400/600'),
    Uebung(name: 'High Pull', beschreibung: 'Explosiv aus der Huefte nach oben ziehen. Ellbogen fuehrt die Bewegung.', muskeln: 'Oberer Ruecken, Schultern', kategorie: 'Ruecken', bildUrl: 'assets/highpull.png'),
    Uebung(name: 'Suitcase Carry', beschreibung: 'Kettlebell einseitig halten. Aufrecht gehen, ohne zur Seite zu kippen.', muskeln: 'Ruecken, Griffkraft, Core', kategorie: 'Ruecken', bildUrl: 'https://picsum.photos/id/28/400/600'),
     
    // 9-12: Oberkörper (4 Übungen)
    Uebung(name: 'Overhead Press', beschreibung: 'Aus der Rack-Position gerade nach oben druecken. Core fest halten.', muskeln: 'Schultern, Trizeps', kategorie: 'Oberkoerper', bildUrl: 'assets/overheadpress.png'),
    Uebung(name: 'Push Press', beschreibung: 'Leichter Schwung aus den Beinen nutzen, um die Kugel nach oben zu druecken.', muskeln: 'Schultern, Beine', kategorie: 'Oberkoerper', bildUrl: 'https://picsum.photos/id/30/400/600'),
    Uebung(name: 'Floor Press', beschreibung: 'Auf dem Boden liegend die Kugel nach oben druecken. Ellbogen beruehrt kurz Boden.', muskeln: 'Brust, Trizeps', kategorie: 'Oberkoerper', bildUrl: 'assets/floorpress.png'),
    Uebung(name: 'Quarter Get-Up', beschreibung: 'Auf dem Ruecken, Arm gestreckt. Auf den Ellbogen aufrollen, Kugel fixieren.', muskeln: 'Schultern, Core', kategorie: 'Oberkoerper', bildUrl: 'https://picsum.photos/id/32/400/600'),
     
    // 13-16: Core (4 Übungen)
    Uebung(name: 'Russian Twist', beschreibung: 'Sitzend, Beine leicht angehoben. Kugel von links nach rechts bewegen.', muskeln: 'Schraege Bauchmuskeln', kategorie: 'Core', bildUrl: 'https://picsum.photos/id/33/400/600'),
    Uebung(name: 'Kettlebell Sit-Up', beschreibung: 'Rueckenlage, Kugel vor der Brust. Kontrolliert aufsetzen.', muskeln: 'Bauchmuskeln', kategorie: 'Core', bildUrl: 'assets/kettlebellsitup.png'),
    // HIER KORRIGIERT: "describe" zu "beschreibung" geändert
    Uebung(name: 'Plank Pull-Through', beschreibung: 'In Liegestuetzposition die Kugel unter dem Körper durchziehen.', muskeln: 'Core-Stabilitaet', kategorie: 'Core', bildUrl: 'assets/plankpullthrough.png'),
    Uebung(name: 'Dead Bug', beschreibung: 'Rueckenlage, Kugel halten. Beine abwechselnd gestreckt absenken.', muskeln: 'Tiefer Core', kategorie: 'Core', bildUrl: 'assets/deadbug.png'),
     
    // 17-19: Ganzkörper (3 Übungen)
    Uebung(name: 'Kettlebell Swing', beschreibung: 'Hüft-Scharnier Bewegung. Kugel durch den Beinschwung auf Brusthöhe bringen.', muskeln: 'Gesaess, Ruecken, Ausdauer', kategorie: 'Ganzkoerper', bildUrl: 'assets/kettlebellswing.png'),
    Uebung(name: 'Clean', beschreibung: 'Kugel explosiv vom Boden in die Rack-Position (Schulter) bringen.', muskeln: 'Ganzkoerper, Koordination', kategorie: 'Ganzkoerper', bildUrl: 'assets/clean.png'),
    Uebung(name: 'Turkish Get-Up', beschreibung: 'Vom Liegen zum Stand aufstehen, waehrend die Kugel ueber Kopf gehalten wird.', muskeln: 'Ganzkoerper, Stabilitaet', kategorie: 'Ganzkoerper', bildUrl: 'https://picsum.photos/id/39/400/600'),
  ];
}

int statistikGesamtMinuten = 0;
int statistikAnzahlWorkouts = 0;
Map<String, int> uebungsZaehler = {};

class HauptNavigationsPage extends StatefulWidget {
  const HauptNavigationsPage({super.key});
  @override
  _HauptNavigationsPageState createState() => _HauptNavigationsPageState();
}

class _HauptNavigationsPageState extends State<HauptNavigationsPage> {
  int _aktuellerIndex = 0;
  final List<Widget> _seiten = [const SlotMachinePage(), const MediathekPage(), const StatistikPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _seiten[_aktuellerIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktuellerIndex,
        selectedItemColor: Colors.orange,
        onTap: (index) => setState(() => _aktuellerIndex = index),
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

  void _spin() {
    final r = Random();
    setState(() {
      _aktuellesWorkout = [
        Uebung.alleUebungen[r.nextInt(5)],       // Unterkörper
        Uebung.alleUebungen[5 + r.nextInt(4)],   // Rücken
        Uebung.alleUebungen[9 + r.nextInt(4)],   // Oberkörper
        Uebung.alleUebungen[13 + r.nextInt(4)],  // Core
        Uebung.alleUebungen[17 + r.nextInt(3)],  // Ganzkörper
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
              children: _aktuellesWorkout.asMap().entries.map((e) => Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.orange, child: Text('${e.key + 1}', style: const TextStyle(color: Colors.black))),
                  title: Text(e.value?.name ?? '?', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(e.value?.kategorie ?? 'Kategorie wählen'),
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _spin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              child: const Text('SPIN!', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            if (!_aktuellesWorkout.contains(null)) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AktiverWorkoutBildschirm(aktuellesWorkout: _aktuellesWorkout.cast<Uebung>()))),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('START ▶️', style: TextStyle(color: Colors.white)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class AktiverWorkoutBildschirm extends StatefulWidget {
  final List<Uebung> aktuellesWorkout;
  const AktiverWorkoutBildschirm({super.key, required this.aktuellesWorkout});
  @override
  _AktiverWorkoutBildschirmState createState() => _AktiverWorkoutBildschirmState();
}

class _AktiverWorkoutBildschirmState extends State<AktiverWorkoutBildschirm> {
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
          statistikGesamtMinuten++;
          uebungsZaehler[widget.aktuellesWorkout[_index].name] = (uebungsZaehler[widget.aktuellesWorkout[_index].name] ?? 0) + 1;
          if (_minutenGespielt >= 30) {
            _timer?.cancel();
            statistikAnzahlWorkouts++;
            _beendet();
          } else {
            _index = (_index + 1) % 5;
          }
        });
      }
    });
  }

  void _beendet() {
    showDialog(context: context, builder: (c) => AlertDialog(title: const Text('🎉 Fertig!'), actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('OK'))]));
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
                    Text(u.beschreibung, textAlign: TextAlign.center),
                    const Spacer(),
                    Text('0:${_sekunden.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Fortschritt: $_minutenGespielt/30 Min', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Abbrechen')),
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

class MediathekPage extends StatefulWidget {
  const MediathekPage({super.key});
  @override
  _MediathekPageState createState() => _MediathekPageState();
}

class _MediathekPageState extends State<MediathekPage> {
  String _filter = 'Alle';
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
              itemBuilder: (c, i) => ListTile(
                title: Text(liste[i].name),
                subtitle: Text(liste[i].kategorie),
                onTap: () => _showDetails(context, liste[i]),
              ),
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
      builder: (context) => DraggableScrollableSheet(
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
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: u.bildUrl.startsWith('http') 
                      ? Image.network(u.bildUrl) 
                      : Image.asset(u.bildUrl, errorBuilder: (c,e,s) => Image.asset('assets/${u.bildUrl.split('/').last}')),
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
                  child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$statistikGesamtMinuten', style: const TextStyle(fontSize: 80, color: Colors.orange, fontWeight: FontWeight.bold)),
            const Text('Minuten trainiert'),
            const SizedBox(height: 30),
            Text('$statistikAnzahlWorkouts', style: const TextStyle(fontSize: 40, color: Colors.green)),
            const Text('Workouts abgeschlossen'),
          ],
        ),
      ),
    );
  }
}
