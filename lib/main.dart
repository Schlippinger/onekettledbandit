import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const OneKettledBanditApp());
}

class OneKettledBanditApp extends StatelessWidget {
  const OneKettledBanditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One-kettled bandit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ==========================================
// MODELLE & DATEN
// ==========================================

enum Schwierigkeit { Anfanger, Fortgeschritten, Profi }

class Uebung {
  final String id;
  final String name;
  final String beschreibung;
  final String muskeln;
  final String kategorie;
  final String bildUrl;
  final int standardWiederholungen;
  final Schwierigkeit schwierigkeit;

  const Uebung({
    required this.id,
    required this.name,
    required this.beschreibung,
    required this.muskeln,
    required this.kategorie,
    required this.bildUrl,
    required this.standardWiederholungen,
    required this.schwierigkeit,
  });
}

class CustomWorkout {
  final String id;
  final String name;
  final List<String> uebungIds;

  CustomWorkout({
    required this.id,
    required this.name,
    required this.uebungIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'uebungIds': uebungIds,
      };

  factory CustomWorkout.fromJson(Map<String, dynamic> json) => CustomWorkout(
        id: json['id'],
        name: json['name'],
        uebungIds: List<String>.from(json['uebungIds']),
      );
}

class ExerciseData {
  static const List<Uebung> alleUebungen = [
    // UNTERKÖRPER
    Uebung(id: 'gobletsquat', name: 'Goblet Squat', beschreibung: 'Kettlebell vor der Brust halten. Fuesse schulterbreit. Gesaess nach hinten absenken.', muskeln: 'Oberschenkel, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'assets/gobletsquat.png', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'singlelegdeadlift', name: 'Single-Leg Deadlift', beschreibung: 'Einbeinig stehen, Huefte nach hinten schieben, Kettlebell kontrolliert senken.', muskeln: 'Beinrueckseite, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/21/400/600', standardWiederholungen: 8, schwierigkeit: Schwierigkeit.Fortgeschritten),
    Uebung(id: 'bulgariansplitsquat', name: 'Bulgarian Split Squat', beschreibung: 'Hinterer Fuss erhöht ablegen. Kettlebell vor der Brust. Tief absenken.', muskeln: 'Beine, Balance', kategorie: 'Unterkoerper', bildUrl: 'assets/bulgariansplitsquad.png', standardWiederholungen: 8, schwierigkeit: Schwierigkeit.Fortgeschritten),
    Uebung(id: 'reverselunge', name: 'Reverse Lunge', beschreibung: 'Aufrechter Stand. Weiten Schritt nach hinten machen. Knie fast zum Boden.', muskeln: 'Beine, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/23/400/600', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'sumosquat', name: 'Sumo Squat', beschreibung: 'Breiter Stand, Zehen nach aussen. Tief absenken.', muskeln: 'Adduktoren, Gesaess', kategorie: 'Unterkoerper', bildUrl: 'https://picsum.photos/id/24/400/600', standardWiederholungen: 12, schwierigkeit: Schwierigkeit.Anfanger),
    
    // RÜCKEN & ZUG
    Uebung(id: 'plankrow', name: 'Plank Row', beschreibung: 'In stabiler Liegestuetzposition aufstützen. Die Kugel abwechselnd zur Huefte ziehen.', muskeln: 'Ruecken, Core, Bizeps', kategorie: 'Ruecken', bildUrl: 'assets/plankrow.png', standardWiederholungen: 8, schwierigkeit: Schwierigkeit.Fortgeschritten),
    Uebung(id: 'staggeredrow', name: 'Staggered Row', beschreibung: 'Versetzter Stand. Gewicht auf vorderem Bein. Einarmig rudern.', muskeln: 'Ruecken, Latissimus', kategorie: 'Ruecken', bildUrl: 'https://picsum.photos/id/26/400/600', standardWiederholungen: 8, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'highpull', name: 'High Pull', beschreibung: 'Explosiv aus der Huefte nach oben ziehen. Ellbogen fuehrt die Bewegung.', muskeln: 'Oberer Ruecken, Schultern', kategorie: 'Ruecken', bildUrl: 'assets/highpull.png', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Fortgeschritten),
    Uebung(id: 'goodmorning', name: 'Good Morning', beschreibung: 'Kugel vor der Brust halten. Mit geradem Ruecken aus der Huefte nach vorne neigen.', muskeln: 'Rückenstrecker, Beinrückseite', kategorie: 'Ruecken', bildUrl: 'https://picsum.photos/id/40/400/600', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'pullover', name: 'Pullover', beschreibung: 'Auf dem Rücken liegen, Kugel mit leicht gebeugten Armen hinter den Kopf führen und zurückziehen.', muskeln: 'Latissimus, Brust, Core', kategorie: 'Ruecken', bildUrl: 'https://picsum.photos/id/41/400/600', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),

    // OBERKÖRPER & DRUCK
    Uebung(id: 'overheadpress', name: 'Overhead Press', beschreibung: 'Aus der Rack-Position gerade nach oben druecken. Core fest halten.', muskeln: 'Schultern, Trizeps', kategorie: 'Oberkoerper', bildUrl: 'assets/overheadpress.png', standardWiederholungen: 6, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'pushpress', name: 'Push Press', beschreibung: 'Leichter Schwung aus den Beinen nutzen, um die Kugel nach oben zu druecken.', muskeln: 'Schultern, Beine', kategorie: 'Oberkoerper', bildUrl: 'https://picsum.photos/id/30/400/600', standardWiederholungen: 8, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'floorpress', name: 'Floor Press', beschreibung: 'Auf dem Boden liegend die Kugel nach oben druecken. Ellbogen beruehrt kurz Boden.', muskeln: 'Brust, Trizeps', kategorie: 'Oberkoerper', bildUrl: 'assets/floorpress.png', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'seatedpress', name: 'Seated Press', beschreibung: 'Auf dem Boden sitzend mit gestreckten Beinen die Kugel ueber Kopf druecken.', muskeln: 'Schultern, Rumpf-Stabilitaet', kategorie: 'Oberkoerper', bildUrl: 'https://picsum.photos/id/42/400/600', standardWiederholungen: 8, schwierigkeit: Schwierigkeit.Fortgeschritten),
    Uebung(id: 'tallkneelingpress', name: 'Tall Kneeling Press', beschreibung: 'Auf beiden Knien stehend aufrecht die Kugel ueber Kopf druecken.', muskeln: 'Schultern, Gesaess, Core', kategorie: 'Oberkoerper', bildUrl: 'https://picsum.photos/id/43/400/600', standardWiederholungen: 8, schwierigkeit: Schwierigkeit.Anfanger),

    // CORE & MOBILITÄT
    Uebung(id: 'halo', name: 'Halo', beschreibung: 'Die Kugel kopfüber eng um den Kopf kreisen lassen.', muskeln: 'Schultermobilität, Core', kategorie: 'Core', bildUrl: 'https://picsum.photos/id/44/400/600', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'tallkneelinghalo', name: 'Tall Kneeling Halo', beschreibung: 'Kniend die Kugel eng um den Kopf kreisen lassen. Hüfte voll gestreckt halten.', muskeln: 'Schultern, Tiefer Core', kategorie: 'Core', bildUrl: 'https://picsum.photos/id/45/400/600', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'pressout', name: 'Press Out', beschreibung: 'In der Hocke oder im Stand die Kugel auf Brusthöhe nach vorne wegdrücken und zurückziehen.', muskeln: 'Bauchmuskeln, Schultern', kategorie: 'Core', bildUrl: 'https://picsum.photos/id/46/400/600', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Fortgeschritten),
    Uebung(id: 'russiantwist', name: 'Russian Twist', beschreibung: 'Sitzend, Beine leicht angehoben. Kugel von links nach rechts bewegen.', muskeln: 'Schraege Bauchmuskeln', kategorie: 'Core', bildUrl: 'https://picsum.photos/id/33/400/600', standardWiederholungen: 16, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'kettlebellsitup', name: 'Kettlebell Sit-Up', beschreibung: 'Rueckenlage, Kugel vor der Brust. Kontrolliert aufsetzen.', muskeln: 'Bauchmuskeln', kategorie: 'Core', bildUrl: 'assets/kettlebellsitup.png', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'plankpullthrough', name: 'Plank Pull-Through', beschreibung: 'In Liegestuetzposition die Kugel unter dem Körper durchziehen.', muskeln: 'Core-Stabilitaet', kategorie: 'Core', bildUrl: 'assets/plankpullthrough.png', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Fortgeschritten),

    // GANZKÖRPER
    Uebung(id: 'kettlebellswing', name: 'Kettlebell Swing', beschreibung: 'Hüft-Scharnier Bewegung. Kugel durch Beinschwung auf Brusthöhe bringen.', muskeln: 'Gesaess, Ruecken, Ausdauer', kategorie: 'Ganzkoerper', bildUrl: 'assets/kettlebellswing.png', standardWiederholungen: 15, schwierigkeit: Schwierigkeit.Anfanger),
    Uebung(id: 'clean', name: 'Clean', beschreibung: 'Kugel explosiv vom Boden in die Rack-Position bringen.', muskeln: 'Ganzkoerper, Koordination', kategorie: 'Ganzkoerper', bildUrl: 'assets/clean.png', standardWiederholungen: 10, schwierigkeit: Schwierigkeit.Fortgeschritten),
    Uebung(id: 'turkishgetup', name: 'Turkish Get-Up', beschreibung: 'Vom Liegen zum Stand aufstehen, waehrend die Kugel ueber Kopf gehalten wird.', muskeln: 'Ganzkoerper, Stabilitaet', kategorie: 'Ganzkoerper', bildUrl: 'https://picsum.photos/id/39/400/600', standardWiederholungen: 3, schwierigkeit: Schwierigkeit.Profi),
    Uebung(id: 'quartergetup', name: 'Quarter Get-Up', beschreibung: 'Auf dem Ruecken, Arm gestreckt. Auf den Ellbogen aufrollen, Kugel fixieren.', muskeln: 'Schultern, Core', kategorie: 'Ganzkoerper', bildUrl: 'https://picsum.photos/id/32/400/600', standardWiederholungen: 5, schwierigkeit: Schwierigkeit.Anfanger),
  ];

  static final List<CustomWorkout> presetWorkouts = [
    CustomWorkout(id: 'p1', name: 'Beginner Full Body', uebungIds: ['gobletsquat', 'staggeredrow', 'overheadpress', 'kettlebellsitup', 'kettlebellswing']),
    CustomWorkout(id: 'p2', name: 'Core & Cardio', uebungIds: ['halo', 'russiantwist', 'pressout', 'plankpullthrough', 'kettlebellswing']),
    CustomWorkout(id: 'p3', name: 'Oberkörper Fokus', uebungIds: ['floorpress', 'seatedpress', 'tallkneelingpress', 'plankrow', 'halo']),
    CustomWorkout(id: 'p4', name: 'Rücken & Core Spezial', uebungIds: ['goodmorning', 'pullover', 'staggeredrow', 'tallkneelinghalo', 'pressout']),
  ];
}

// ==========================================
// HAUPT-NAVIGATION
// ==========================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WorkoutHubScreen(),
    const MediathekScreen(),
    const StatisikScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E1E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Mediathek'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistik'),
        ],
      ),
    );
  }
}

// ==========================================
// WORKOUT HUB (TAB 1)
// ==========================================

class WorkoutHubScreen extends StatefulWidget {
  const WorkoutHubScreen({super.key});

  @override
  State<WorkoutHubScreen> createState() => _WorkoutHubScreenState();
}

class _WorkoutHubScreenState extends State<WorkoutHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One-kettled bandit 🎰'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Slot Machine'),
            Tab(text: 'Erstellen'),
            Tab(text: 'Gespeichert'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SlotMachineTab(),
          CreateWorkoutTab(),
          SavedWorkoutsTab(),
        ],
      ),
    );
  }
}

// --- TAB 1A: SLOT MACHINE ---
class SlotMachineTab extends StatefulWidget {
  const SlotMachineTab({super.key});

  @override
  State<SlotMachineTab> createState() => _SlotMachineTabState();
}

class _SlotMachineTabState extends State<SlotMachineTab> {
  Schwierigkeit? _selectedDifficulty; // null = Alle
  List<Uebung> _currentSelection = [];

  @override
  void initState() {
    super.initState();
    _generateRandomWorkout();
  }

  void _generateRandomWorkout() {
    final pool = ExerciseData.alleUebungen.where((u) {
      if (_selectedDifficulty == null) return true;
      return u.schwierigkeit == _selectedDifficulty;
    }).toList();

    pool.shuffle();
    setState(() {
      _currentSelection = pool.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter:', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<Schwierigkeit?>(
                value: _selectedDifficulty,
                hint: const Text('Alle Schwierigkeiten'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Alle Übungen')),
                  ...Schwierigkeit.values.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.name),
                      )),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedDifficulty = val;
                  });
                  _generateRandomWorkout();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _currentSelection.length,
              itemBuilder: (context, i) {
                final u = _currentSelection[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(u.name),
                    subtitle: Text('${u.kategorie} • ${u.schwierigkeit.name}'),
                    trailing: Text('${u.standardWiederholungen} Wh.'),
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: _generateRandomWorkout,
            icon: const Icon(Icons.casino),
            label: const Text('NEU DREHEN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// --- TAB 1B: WORKOUT ERSTELLEN ---
class CreateWorkoutTab extends StatefulWidget {
  const CreateWorkoutTab({super.key});

  @override
  State<CreateWorkoutTab> createState() => _CreateWorkoutTabState();
}

class _CreateWorkoutTabState extends State<CreateWorkoutTab> {
  final List<Uebung> _selectedUebungen = [];
  final TextEditingController _nameController = TextEditingController();

  void _toggleUebung(Uebung u) {
    setState(() {
      if (_selectedUebungen.contains(u)) {
        _selectedUebungen.remove(u);
      } else {
        if (_selectedUebungen.length < 5) {
          _selectedUebungen.add(u);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximal 5 Übungen erlaubt!')),
          );
        }
      }
    });
  }

  Future<void> _saveWorkout() async {
    if (_nameController.text.trim().isEmpty || _selectedUebungen.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Namen eingeben und mind. 1 Übung wählen.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList('custom_workouts') ?? [];

    final newWorkout = CustomWorkout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      uebungIds: _selectedUebungen.map((u) => u.id).toList(),
    );

    rawList.add(jsonEncode(newWorkout.toJson()));
    await prefs.setStringList('custom_workouts', rawList);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout erfolgreich gespeichert!')),
      );
      setState(() {
        _selectedUebungen.clear();
        _nameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Workout Name (z.B. Mein Rumpf-Zirkel)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ausgewählt (${_selectedUebungen.length}/5):',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          // Horizontal gewählte Übungen anzeigen (mit Löschen-Funktion & Aufrücken)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedUebungen.length,
              itemBuilder: (context, i) {
                final u = _selectedUebungen[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    avatar: CircleAvatar(child: Text('${i + 1}')),
                    label: Text(u.name),
                    onDeleted: () => _toggleUebung(u),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const Text('Übungspool (Klicken zum Hinzufügen/Entfernen):'),
          Expanded(
            child: ListView.builder(
              itemCount: ExerciseData.alleUebungen.length,
              itemBuilder: (context, i) {
                final u = ExerciseData.alleUebungen[i];
                final isSelected = _selectedUebungen.contains(u);
                return ListTile(
                  title: Text(u.name),
                  subtitle: Text('${u.kategorie} • ${u.schwierigkeit.name}'),
                  trailing: Icon(
                    isSelected ? Icons.check_circle : Icons.add_circle_outline,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                  onTap: () => _toggleUebung(u),
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
            onPressed: _saveWorkout,
            child: const Text('WORKOUT SPEICHERN'),
          )
        ],
      ),
    );
  }
}

// --- TAB 1C: GESPEICHERTE & PRESET WORKOUTS ---
class SavedWorkoutsTab extends StatefulWidget {
  const SavedWorkoutsTab({super.key});

  @override
  State<SavedWorkoutsTab> createState() => _SavedWorkoutsTabState();
}

class _SavedWorkoutsTabState extends State<SavedWorkoutsTab> {
  List<CustomWorkout> _userWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadUserWorkouts();
  }

  Future<void> _loadUserWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> rawList = prefs.getStringList('custom_workouts') ?? [];
    setState(() {
      _userWorkouts = rawList.map((str) => CustomWorkout.fromJson(jsonDecode(str))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Vordefinierte Workouts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...ExerciseData.presetWorkouts.map((w) => _buildWorkoutCard(w, isPreset: true)),
        const SizedBox(height: 20),
        const Text('Meine eigenen Workouts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (_userWorkouts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Noch keine eigenen Workouts erstellt.'),
          )
        else
          ..._userWorkouts.map((w) => _buildWorkoutCard(w, isPreset: false)),
      ],
    );
  }

  Widget _buildWorkoutCard(CustomWorkout w, {required bool isPreset}) {
    final uebungen = w.uebungIds.map((id) => ExerciseData.alleUebungen.firstWhere((u) => u.id == id, orElse: () => ExerciseData.alleUebungen[0])).toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${uebungen.length} Übungen'),
        children: [
          ...uebungen.map((u) => ListTile(
                dense: true,
                title: Text(u.name),
                subtitle: Text(u.kategorie),
              )),
        ],
      ),
    );
  }
}

// ==========================================
// MEDIATHEK (TAB 2)
// ==========================================

class MediathekScreen extends StatefulWidget {
  const MediathekScreen({super.key});

  @override
  State<MediathekScreen> createState() => _MediathekScreenState();
}

class _MediathekScreenState extends State<MediathekScreen> {
  Schwierigkeit? _filterDifficulty;

  @override
  Widget build(BuildContext context) {
    final gefiltert = ExerciseData.alleUebungen.where((u) {
      if (_filterDifficulty == null) return true;
      return u.schwierigkeit == _filterDifficulty;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Übungs-Mediathek 📚'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Schwierigkeit filtern:'),
                DropdownButton<Schwierigkeit?>(
                  value: _filterDifficulty,
                  hint: const Text('Alle'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Alle Übungen')),
                    ...Schwierigkeit.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))),
                  ],
                  onChanged: (val) => setState(() => _filterDifficulty = val),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gefiltert.length,
              itemBuilder: (context, index) {
                final u = gefiltert[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${u.kategorie} • ${u.muskeln}\n${u.beschreibung}'),
                    trailing: Chip(label: Text(u.schwierigkeit.name)),
                    isThreeLine: true,
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

// ==========================================
// STATISTIK (TAB 3)
// ==========================================

class StatisikScreen extends StatelessWidget {
  const StatisikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik & Level 📊')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 80, color: Color(0xFFFF6B00)),
            SizedBox(height: 16),
            Text('Level 1: Kettlebell-Novize', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Absolviere Workouts, um Punkte & Streaks zu sammeln!'),
          ],
        ),
      ),
    );
  }
}
