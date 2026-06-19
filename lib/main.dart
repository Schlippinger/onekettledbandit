import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:wakelock_plus/wakelock_plus.dart';

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

  const Uebung({
    required this.name,
    required this.beschreibung,
    required this.muskeln,
    required this.kategorie,
    required this.bildUrl,
  });

  // Hier als statische Liste innerhalb der Klasse, um Compiler-Scope-Fehler zu vermeiden
  static const List<Uebung> alleUebungen = [
    Uebung(
        name: 'Goblet Squat',
        beschreibung: 'Kettlebell vor der Brust halten. Fuesse etwa schulterbreit. Gesaess nach hinten unten fuehren.',
        muskeln: 'Oberschenkel, Gesaess, Core',
        kategorie: 'Unterkoerper',
        bildUrl: 'assets/gobletsquat.png'),
    Uebung(
        name: 'Single-Leg Deadlift',
        beschreibung: 'Auf einem Bein stehen, das andere nach hinten anheben. Huefte nach hinten schieben.',
        muskeln: 'Gesaess, hintere Oberschenkel, Ruecken',
        kategorie: 'Unterkoerper',
        bildUrl: 'https://picsum.photos/id/21/400/600'),
    Uebung(
        name: 'Bulgarian Split Squat',
        beschreibung: 'Hinteren Fuss auf Bank ablegen. Kettlebell vor der Brust halten. Kontrolliert absenken.',
        muskeln: 'Beine, Gesaess, Gleichgewicht',
        kategorie: 'Unterkoerper',
        bildUrl: 'assets/bulgariansplitsquad.png'),
    Uebung(
        name: 'Reverse Lunge',
        beschreibung: 'Kettlebell vor der Brust halten. Grossen Schritt nach hinten machen.',
        muskeln: 'Beine, Gesaess, Core',
        kategorie: 'Unterkoerper',
        bildUrl: 'https://picsum.photos/id/23/400/600'),
    Uebung(
        name: 'Sumo Squat',
        beschreibung: 'Breiter Stand, Fussspitzen nach aussen. Tief absenken und drei Sekunden halten.',
        muskeln: 'Innenschenkel, Gesaess, Beine',
        kategorie: 'Unterkoerper',
        bildUrl: 'https://picsum.photos/id/24/400/600'),
    Uebung(
        name: 'Einarmiges Rudern',
        beschreibung: 'Hand auf Knie abstuetzen. Kettlebell zur Huefte ziehen.',
        muskeln: 'Oberer Ruecken, Latissimus, Bizeps',
        kategorie: 'Ruecken',
        bildUrl: 'assets/einarmigesrudern.png'),
    Uebung(
        name: 'Staggered Row',
        beschreibung: 'Ausfallschritt, auf Oberschenkel abstuetzen und einarmig zur Huefte rudern.',
        muskeln: 'Ruecken, Core',
        kategorie: 'Ruecken',
        bildUrl: 'https://picsum.photos/id/26/400/600'),
    Uebung(
        name: 'High Pull',
        beschreibung: 'Aus der Huefte Schwung holen. Ellbogen fuehrt nach oben oder aussen.',
        muskeln: 'Ruecken, Schultern, Huefte',
        kategorie: 'Ruecken',
        bildUrl: 'assets/highpull.png'),
    Uebung(
        name: 'Suitcase Carry',
        beschreibung: 'Kettlebell einseitig wie einen Koffer tragen. Aufrecht gehen.',
        muskeln: 'Ruecken, Griffkraft, seitlicher Core',
        kategorie: 'Ruecken',
        bildUrl: 'https://picsum.photos/id/28/400/600'),
    Uebung(
        name: 'Overhead Press',
        beschreibung: 'Aus der Rack-Position ueber den Kopf druecken.',
        muskeln: 'Schultern, Trizeps, Core',
        kategorie: 'Oberkoerper',
        bildUrl: 'assets/overheadpress.png'),
    Uebung(
        name: 'Push Press',
        beschreibung: 'Kettlebell einarmig in Rack-Position halten, durch leichten Beinschwung explosiv ueber den Kopf druecken.',
        muskeln: 'Schultern, Trizeps, Beine, Core',
        kategorie: 'Oberkoerper',
        bildUrl: 'https://picsum.photos/id/30/400/600'),
    Uebung(
        name: 'Floor Press',
        beschreibung: 'Auf dem Ruecken liegen. Von der Brust nach oben druecken.',
        muskeln: 'Brust, Trizeps, Schultern',
        kategorie: 'Oberkoerper',
        bildUrl: 'assets/floorpress.png'),
    Uebung(
        name: 'Quarter Get-Up',
        beschreibung: 'Rueckenlage. Kettlebell nach oben strecken. Aufrichten bis zum Ellbogen.',
        muskeln: 'Schulterstabilitaet, Core',
        kategorie: 'Oberkoerper',
        bildUrl: 'https://picsum.photos/id/32/400/600'),
    Uebung(
        name: 'Russian Twist',
        beschreibung: 'Sitzen, leicht zuruecklehnen. Kettlebell von Seite zu Seite bewegen.',
        muskeln: 'Schraeg Bauchmuskeln',
        kategorie: 'Core',
        bildUrl: 'https://picsum.photos/id/33/400/600'),
    Uebung(
        name: 'Kettlebell Sit-Up',
        beschreibung: 'Rueckenlage. Kettlebell vor der Brust halten. Aufrichten.',
        muskeln: 'Gerade Bauchmuskulatur',
        kategorie: 'Core',
        bildUrl: 'assets/kettlebellsitup.png'),
    Uebung(
        name: 'Plank Pull-Through',
        beschreibung: 'Unterarmstuetz. Kettlebell unter dem Koerper auf die andere Seite ziehen.',
        muskeln: 'Gesamte Bauchmuskulatur, Schulterstabilitaet',
        kategorie: 'Core',
        bildUrl: 'assets/plankpullthrough.png'),
    Uebung(
        name: 'Dead Bug',
        beschreibung: 'Rueckenlage. Kettlebell mit gestreckten Armen halten. Beine wechselnd strecken.',
        muskeln: 'Tiefe Bauchmuskulatur',
        kategorie: 'Core',
        bildUrl: 'assets/deadbug.png'),
    Uebung(
        name: 'Kettlebell Swing',
        beschreibung: 'Aus der Huefte schwingen. Kugel fliegt bis auf Brusthoehe.',
        muskeln: 'Gesaess, Ruecken, Core, Kondition',
        kategorie: 'Ganzkoerper',
        bildUrl: 'assets/kettlebellswing.png'),
    Uebung(
        name: 'Clean',
        beschreibung: 'Aus dem Schwung eng am Koerper in die Rack-Position fuehren.',
        muskeln: 'Ganzkoerper, Koordination',
        kategorie: 'Ganzkoerper',
        bildUrl: 'assets/clean.png'),
    Uebung(
        name: 'Turkish Get-Up',
        beschreibung: 'Vom Liegen mit ausgestrecktem Arm schrittweise zum Stand aufstehen.',
        muskeln: 'Gesamter Koerper, Stabilitaet, Mobilitaet',
        kategorie: 'Ganzkoerper',
        bildUrl: 'https://picsum.photos/id/39/400/600'),
  ];
}

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
      _aktuellesWorkout = [
        Uebung.alleUebungen[random.nextInt(5)],       
        Uebung.alleUebungen[5 + random.nextInt(4)],   
        Uebung.alleUebungen[9 + random.nextInt(4)],   
        Uebung.alleUebungen[13 + random.nextInt(4)],  
        Uebung.alleUebungen[17 + random.nextInt(3)],  
      ];
      _aktuellesWorkout.shuffle(random);
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
    WakelockPlus.enable();
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
        content: Text('Du hast das 30-minuetige Kettlebell-Workout beendet!'),
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
    WakelockPlus.disable();
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
                    errorBuilder: (context, error, stackTrace) {
                      final altPfad = uebung.bildUrl.startsWith('assets/') ? uebung.bildUrl : 'assets/${uebung.bildUrl}';
                      return Image.asset(
                        altPfad,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: Colors.grey[900],
                          child: Icon(Icons.fitness_center, size: 80, color: Colors.orange),
                        ),
                      );
                    },
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
                      Text('UEBUNG ${_aktuelleUebungIndex + 1} VON 5',
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

  final List<String> _kategorien = ['Alle', 'Unterkoerper', 'Ruecken', 'Oberkoerper', 'Core', 'Ganzkoerper'];
  final List<String> _sortierOptionen = ['Alphabetisch (A-Z)', 'Nach Muskelgruppe'];

  @override
  Widget build(BuildContext context) {
    List<Uebung> gefilterteListe = Uebung.alleUebungen.where((uebung) {
      if (_ausgewaehlterFilter == 'Alle') return true;
      return uebung.kategorie == _ausgewaehlterFilter;
    }).toList();

    if (_ausgewaehlteSortierung == 'Alphabetisch (A-Z)') {
      gefilterteListe.sort((a, b) => a.name.compareTo(b.name));
    } else if (_ausgewaehlteSortierung == 'Nach Muskelgruppe') {
      gefilterteListe.sort((a, b) => a.kategorie.compareTo(b.kategorie));
    }

    return Scaffold(
      appBar: AppBar(title: Text('📚 Uebungs-Mediathek'), backgroundColor: Colors.black),
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
            child: gefilterteListe.isEmpty
                ? Center(child: Text('Keine Uebungen fuer diesen Filter gefunden.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: gefilterteListe.length,
                    itemBuilder: (context, index) {
                      Uebung uebung = gefilterteListe[index];
                      return Card(
                        color: Colors.grey[900],
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: Icon(Icons.fitness_center, color: Colors.orange),
                          title: Text(uebung.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${uebung.kategorie} • ${uebung.muskeln}',
                              maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.95,
                                minChildSize: 0.5,
                                maxChildSize: 1.0,
                                expand: false,
                                builder: (context, scrollController) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[950],
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  child: Stack(
                                    children: [
                                      SingleChildScrollView(
                                        controller: scrollController,
                                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 40,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[700],
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Padding(
                                              padding: const EdgeInsets.right(40.0),
                                              child: Text(
                                                uebung.name, 
                                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange)
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text('Kategorie: ${uebung.kategorie}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                                            Text('Fokus: ${uebung.muskeln}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                                            Divider(color: Colors.grey, height: 25),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: uebung.bildUrl.startsWith('http')
                                                  ? Image.network(
                                                      uebung.bildUrl,
                                                      width: double.infinity,
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (c, e, s) => Container(),
                                                    )
                                                  : Image.asset(
                                                      uebung.bildUrl,
                                                      width: double.infinity,
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        final altPfad = uebung.bildUrl.startsWith('assets/') ? uebung.bildUrl : 'assets/${uebung.bildUrl}';
                                                        return Image.asset(
                                                          altPfad,
                                                          width: double.infinity,
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (c, e, s) => Container(),
                                                        );
                                                      },
                                                    ),
                                            ),
                                            SizedBox(height: 25),
                                            Text('Ausfuehrung:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                                            SizedBox(height: 8),
                                            Text(uebung.beschreibung, style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[200])),
                                            SizedBox(height: 40),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 15,
                                        right: 15,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[900]?.withOpacity(0.8),
                                          child: IconButton(
                                            icon: Icon(Icons.close, color: Colors.white),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
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
}

class StatistikPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📊 Deine Erfolge'), backgroundColor: Colors.black),
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
                          Text('$statistikGesamtMinuten', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange)),
                          Text('Minuten trainiert', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
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
                          Text('$statistikAnzahlWorkouts', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green)),
                          Text('Workouts beendet', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text('Haeufigkeit der Uebungen:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: uebungsZaehler.isEmpty
                  ? Center(child: Text('Noch keine Daten vorhanden.\nStarte ein Workout!', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center))
                  : ListView(
                      children: uebungsZaehler.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Chip(
                            backgroundColor: Colors.orange,
                            label: Text('${entry.value}x', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
