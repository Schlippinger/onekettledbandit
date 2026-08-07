import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KettlebellApp());
}

class KettlebellApp extends StatelessWidget {
  const KettlebellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KB Club Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020617),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF0F172A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String category;
  final String description;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
  });
}

const List<Exercise> exerciseLibrary = [
  Exercise(
      id: 'swings',
      name: 'Kettlebell Swings',
      category: 'Pull/Posterior',
      description: 'Hüftdominante Explosivübung für Posterior Chain.'),
  Exercise(
      id: 'goblet_squat',
      name: 'Goblet Squats',
      category: 'Legs',
      description: 'Tiefe Kniebeuge mit KB vor der Brust.'),
  Exercise(
      id: 'overhead_press',
      name: 'Strict Overhead Press',
      category: 'Push',
      description: 'Schulterdrücken im festen Stand.'),
  Exercise(
      id: 'push_press',
      name: 'Push Press',
      category: 'Push',
      description: 'Schulterdrücken mit leichtem Schwung aus den Beinen.'),
  Exercise(
      id: 'snatch',
      name: 'KB Snatch',
      category: 'Full Body',
      description: 'Explosives Reißen über den Kopf.'),
  Exercise(
      id: 'clean_press',
      name: 'Clean & Press',
      category: 'Full Body',
      description: 'Umsetzen auf Brusthöhe mit anschließendem Drücken.'),
  Exercise(
      id: 'turkish_getup',
      name: 'Turkish Get-Up',
      category: 'Core/Full Body',
      description: 'Komplexe Ganzkörperübung im Aufstehen.'),
  Exercise(
      id: 'situps',
      name: 'KB Sit-Ups',
      category: 'Core',
      description: 'Rumpfbeugen mit Zusatzgewicht an der Brust.'),
  Exercise(
      id: 'renegade_row',
      name: 'Renegade Rows',
      category: 'Pull',
      description: 'Liegestützposition mit wechselseitigem Rudern.'),
];

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SlotMachineScreen(),
    const CustomWorkoutScreen(),
    const SavedWorkoutsScreen(),
    const LibraryScreen(),
    const StatsAchievementsScreen(),
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
        selectedItemColor: const Color(0xFF22C55E),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF0F172A),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Slot'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Erstellen'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Gespeichert'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Übungen'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Erfolge'),
        ],
      ),
    );
  }
}

class SlotMachineScreen extends StatefulWidget {
  const SlotMachineScreen({super.key});

  @override
  State<SlotMachineScreen> createState() => _SlotMachineScreenState();
}

class _SlotMachineScreenState extends State<SlotMachineScreen> {
  String _selectedMode = 'EMOM';
  int _amrapMinutes = 12;
  bool _isSpinning = false;
  List<Exercise> _generatedSlots = [];

  void _spinSlots() {
    setState(() {
      _isSpinning = true;
    });

    Timer(const Duration(milliseconds: 600), () {
      final random = Random();
      final List<Exercise> shuffled = List.from(exerciseLibrary)..shuffle(random);

      setState(() {
        _generatedSlots = shuffled.take(4).toList();
        _isSpinning = false;
      });
    });
  }

  void _saveCurrentWorkout() async {
    if (_generatedSlots.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('saved_workouts') ?? [];
    
    final workoutSummary = '$_selectedMode: ' + _generatedSlots.map((e) => e.name).join(', ');
    saved.add(workoutSummary);
    await prefs.setStringList('saved_workouts', saved);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout erfolgreich gespeichert!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KB Workout Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Workout Modus:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'EMOM', label: Text('EMOM')),
                        ButtonSegment(value: 'AMRAP', label: Text('AMRAP')),
                        ButtonSegment(value: 'For Time', label: Text('For Time')),
                      ],
                      selected: {_selectedMode},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedMode = newSelection.first;
                        });
                      },
                    ),
                    if (_selectedMode == 'AMRAP') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Zeit (Minuten): '),
                          DropdownButton<int>(
                            value: _amrapMinutes,
                            dropdownColor: const Color(0xFF1E293B),
                            items: [8, 10, 12, 15, 20].map((int val) {
                              return DropdownMenuItem<int>(value: val, child: Text('$val Min'));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _amrapMinutes = val);
                            },
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSpinning ? null : _spinSlots,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.casino, color: Colors.black),
              label: Text(
                _isSpinning ? 'Mische Übungen...' : 'SLOT MACHINE DREHEN',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (_generatedSlots.isNotEmpty) ...[
              Text(
                'Dein Workout ($_selectedMode):',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _generatedSlots.length,
                itemBuilder: (context, index) {
                  final ex = _generatedSlots[index];
                  return Card(
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF22C55E),
                        child: Text('${index + 1}', style: const TextStyle(color: Colors.black)),
                      ),
                      title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(ex.category),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _saveCurrentWorkout,
                icon: const Icon(Icons.bookmark_add),
                label: const Text('Speichern'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomWorkoutScreen extends StatefulWidget {
  const CustomWorkoutScreen({super.key});

  @override
  State<CustomWorkoutScreen> createState() => _CustomWorkoutScreenState();
}

class _CustomWorkoutScreenState extends State<CustomWorkoutScreen> {
  final _titleController = TextEditingController();
  final List<Exercise> _selectedExercises = [];

  void _addExercise(Exercise ex) {
    setState(() {
      _selectedExercises.add(ex);
    });
  }

  void _saveCustomWorkout() async {
    if (_titleController.text.isEmpty || _selectedExercises.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('saved_workouts') ?? [];
    
    final workoutSummary = '${_titleController.text}: ' + _selectedExercises.map((e) => e.name).join(', ');
    saved.add(workoutSummary);
    await prefs.setStringList('saved_workouts', saved);

    _titleController.clear();
    setState(() {
      _selectedExercises.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Manuelles Workout gespeichert!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Erstellen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Workout Name (z.B. Montag Kraft)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ausgewählte Übungen:', style: TextStyle(fontWeight: FontWeight.bold)),
                PopupMenuButton<Exercise>(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF22C55E)),
                  onSelected: _addExercise,
                  itemBuilder: (context) {
                    return exerciseLibrary.map((ex) {
                      return PopupMenuItem(value: ex, child: Text(ex.name));
                    }).toList();
                  },
                )
              ],
            ),
            Expanded(
              child: _selectedExercises.isEmpty
                  ? const Center(child: Text('Füge Übungen über das + Symbol hinzu.'))
                  : ListView.builder(
                      itemCount: _selectedExercises.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_selectedExercises[index].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                _selectedExercises.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _saveCustomWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Workout Speichern', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedWorkoutsScreen extends StatefulWidget {
  const SavedWorkoutsScreen({super.key});

  @override
  State<SavedWorkoutsScreen> createState() => _SavedWorkoutsScreenState();
}

class _SavedWorkoutsScreenState extends State<SavedWorkoutsScreen> {
  List<String> _savedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadSavedWorkouts();
  }

  void _loadSavedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedWorkouts = prefs.getStringList('saved_workouts') ?? [];
    });
  }

  void _deleteWorkout(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedWorkouts.removeAt(index);
    });
    await prefs.setStringList('saved_workouts', _savedWorkouts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gespeicherte Workouts')),
      body: _savedWorkouts.isEmpty
          ? const Center(child: Text('Noch keine gespeicherten Workouts.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedWorkouts.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(_savedWorkouts[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteWorkout(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kettlebell Mediathek')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exerciseLibrary.length,
        itemBuilder: (context, index) {
          final ex = exerciseLibrary[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: const Icon(Icons.fitness_center, color: Color(0xFF22C55E)),
              title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(ex.category),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(ex.description, style: const TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatsAchievementsScreen extends StatelessWidget {
  const StatsAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats & Erfolge')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF1E293B),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('12', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF22C55E))),
                        Text('Workouts'),
                      ],
                    ),
                    Column(
                      children: [
                        Text('180', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6))),
                        Text('Minuten'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Erfolge:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.emoji_events, color: Colors.amber),
                    title: Text('Erster Spin'),
                    subtitle: Text('Slot Machine zum ersten Mal genutzt.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center, color: Colors.grey),
                    title: Text('Kettlebell Master'),
                    subtitle: Text('Schließe 10 Workouts ab.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
