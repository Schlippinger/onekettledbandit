<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>One Kettled Bandit - KB Manager</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @keyframes spin {
            0% { transform: translateY(-100%); opacity: 0; }
            50% { opacity: 0.5; }
            100% { transform: translateY(0); opacity: 1; }
        }
        .animate-slot { animation: spin 0.4s ease-out; }
    </style>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen flex flex-col font-sans">

    <!-- Header -->
    <header class="bg-slate-900 border-b border-slate-800 p-4 sticky top-0 z-50">
        <div class="max-w-md mx-auto flex justify-between items-center">
            <h1 class="text-xl font-bold text-emerald-400 flex items-center gap-2">
                <i data-lucide="dices"></i> One Kettled Bandit
            </h1>
            <span id="streak-badge" class="bg-slate-800 text-amber-400 text-xs px-2.5 py-1 rounded-full border border-slate-700 flex items-center gap-1">
                <i data-lucide="flame" class="w-3.5 h-3.5"></i> <span id="streak-count">0</span> Tage
            </span>
        </div>
    </header>

    <!-- Main Content Container -->
    <main class="flex-1 max-w-md w-full mx-auto p-4 pb-24">
        
        <!-- SECTION 1: SLOT MACHINE -->
        <section id="sec-slot" class="space-y-4">
            <div class="bg-slate-900 border border-slate-800 rounded-xl p-4">
                <label class="block text-sm font-medium mb-2 text-slate-400">Workout Modus</label>
                <div class="grid grid-cols-3 gap-2">
                    <button onclick="setMode('EMOM')" id="btn-emom" class="mode-btn bg-emerald-600 text-white font-semibold py-2 rounded-lg text-sm">EMOM</button>
                    <button onclick="setMode('AMRAP')" id="btn-amrap" class="mode-btn bg-slate-800 text-slate-300 font-semibold py-2 rounded-lg text-sm">AMRAP</button>
                    <button onclick="setMode('For Time')" id="btn-fortime" class="mode-btn bg-slate-800 text-slate-300 font-semibold py-2 rounded-lg text-sm">For Time</button>
                </div>
            </div>

            <button onclick="spinSlots()" class="w-full bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-bold py-4 rounded-xl shadow-lg transition active:scale-95 flex items-center justify-center gap-2 text-lg">
                <i data-lucide="rotate-cw"></i> SLOT MACHINE DREHEN
            </button>

            <!-- Slot Results -->
            <div id="slot-results" class="space-y-3">
                <div class="text-center py-8 text-slate-500">Klicke auf Drehen, um ein Workout zu generieren!</div>
            </div>

            <div id="slot-actions" class="hidden flex gap-2">
                <button onclick="startWorkout()" class="flex-1 bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-lg flex items-center justify-center gap-2">
                    <i data-lucide="play"></i> Starten
                </button>
                <button onclick="saveCurrentSlot()" class="bg-slate-800 hover:bg-slate-700 text-slate-200 px-4 py-3 rounded-lg flex items-center justify-center">
                    <i data-lucide="bookmark"></i>
                </button>
            </div>
        </section>

        <!-- SECTION 2: TIMER (Standardmäßig verborgen) -->
        <section id="sec-timer" class="hidden space-y-6 text-center py-6">
            <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6">
                <span id="timer-mode-label" class="text-emerald-400 text-sm font-semibold uppercase tracking-wider">EMOM</span>
                <div id="timer-display" class="text-6xl font-black my-4 tracking-tight">01:00</div>
                <p id="timer-exercise" class="text-lg text-slate-300 font-medium">Bereit machen...</p>
            </div>
            <div class="flex gap-4">
                <button onclick="toggleTimer()" id="btn-timer-control" class="flex-1 bg-emerald-500 text-slate-950 font-bold py-3 rounded-xl">Start</button>
                <button onclick="resetTimer()" class="bg-slate-800 text-slate-300 px-6 py-3 rounded-xl">Beenden</button>
            </div>
        </section>

        <!-- SECTION 3: WORKOUT ERSTELLEN -->
        <section id="sec-custom" class="hidden space-y-4">
            <h2 class="text-lg font-bold text-slate-200">Eigenes Workout erstellen</h2>
            <input type="text" id="custom-name" placeholder="Workout Name (z.B. Montag Kraft)" class="w-full bg-slate-900 border border-slate-800 rounded-lg p-3 text-sm text-slate-100 focus:outline-none focus:border-emerald-500">
            <div id="custom-exercises-list" class="space-y-2"></div>
            <button onclick="addExerciseToCustom()" class="w-full border border-dashed border-slate-700 text-slate-400 py-3 rounded-lg text-sm hover:text-slate-200">+ Übung hinzufügen</button>
            <button onclick="saveCustomWorkout()" class="w-full bg-emerald-500 text-slate-950 font-bold py-3 rounded-lg">Workout Speichern</button>
        </section>

        <!-- SECTION 4: MEDIATHEK -->
        <section id="sec-library" class="hidden space-y-3">
            <h2 class="text-lg font-bold text-slate-200 mb-2">Übungs-Mediathek</h2>
            <div id="library-list" class="space-y-2"></div>
        </section>

        <!-- SECTION 5: ERFOLGE -->
        <section id="sec-stats" class="hidden space-y-4">
            <div class="grid grid-cols-2 gap-3">
                <div class="bg-slate-900 p-4 border border-slate-800 rounded-xl text-center">
                    <div id="stat-completed" class="text-2xl font-bold text-emerald-400">0</div>
                    <div class="text-xs text-slate-400">Absolvierte Workouts</div>
                </div>
                <div class="bg-slate-900 p-4 border border-slate-800 rounded-xl text-center">
                    <div id="stat-spins" class="text-2xl font-bold text-blue-400">0</div>
                    <div class="text-xs text-slate-400">Spins Durchgeführt</div>
                </div>
            </div>
        </section>
    </main>

    <!-- Bottom Navigation -->
    <nav class="fixed bottom-0 left-0 right-0 bg-slate-900/95 backdrop-blur border-t border-slate-800">
        <div class="max-w-md mx-auto flex justify-around p-2">
            <button onclick="nav('slot')" id="nav-slot" class="flex flex-col items-center gap-1 p-2 text-emerald-400 text-xs">
                <i data-lucide="casino" class="w-5 h-5"></i> Slot
            </button>
            <button onclick="nav('custom')" id="nav-custom" class="flex flex-col items-center gap-1 p-2 text-slate-400 text-xs">
                <i data-lucide="plus-circle" class="w-5 h-5"></i> Erstellen
            </button>
            <button onclick="nav('library')" id="nav-library" class="flex flex-col items-center gap-1 p-2 text-slate-400 text-xs">
                <i data-lucide="book-open" class="w-5 h-5"></i> Übungen
            </button>
            <button onclick="nav('stats')" id="nav-stats" class="flex flex-col items-center gap-1 p-2 text-slate-400 text-xs">
                <i data-lucide="trophy" class="w-5 h-5"></i> Erfolge
            </button>
        </div>
    </nav>

    <!-- JavaScript Logik -->
    <script>
        const exercises = [
            { id: 1, name: 'Kettlebell Swings', cat: 'Posterior', desc: 'Explosive Hüftstreckung aus der Beuge.' },
            { id: 2, name: 'Goblet Squats', cat: 'Beine', desc: 'Tiefe Kniebeuge mit KB vor der Brust.' },
            { id: 3, name: 'Strict Overhead Press', cat: 'Schultern', desc: 'Sauberes Drücken über den Kopf.' },
            { id: 4, name: 'Push Press', cat: 'Schultern/Beine', desc: 'Schwungvolles Drücken mit Beinunterstützung.' },
            { id: 5, name: 'KB Sit-Ups', cat: 'Core', desc: 'Rumpfbeugen mit Zusatzgewicht.' },
            { id: 6, name: 'Turkish Get-Up', cat: 'Ganzkörper', desc: 'Langsames Aufstehen aus dem Liegen mit KB.' }
        ];

        let currentMode = 'EMOM';
        let currentWorkout = [];
        let timerInterval = null;

        function init() {
            lucide.createIcons();
            renderLibrary();
            loadStats();
        }

        function setMode(mode) {
            currentMode = mode;
            document.querySelectorAll('.mode-btn').forEach(b => {
                b.className = 'mode-btn bg-slate-800 text-slate-300 font-semibold py-2 rounded-lg text-sm';
            });
            document.getElementById(`btn-${mode.toLowerCase().replace(' ', '')}`).className = 'mode-btn bg-emerald-600 text-white font-semibold py-2 rounded-lg text-sm';
        }

        function spinSlots() {
            const results = document.getElementById('slot-results');
            results.innerHTML = '';
            
            // Zufällige 4 Übungen wählen
            const shuffled = [...exercises].sort(() => 0.5 - Math.random());
            currentWorkout = shuffled.slice(0, 4);

            currentWorkout.forEach((ex, idx) => {
                const card = document.createElement('div');
                card.className = 'bg-slate-900 border border-slate-800 p-3 rounded-lg flex justify-between items-center animate-slot';
                card.innerHTML = `
                    <div class="flex items-center gap-3">
                        <span class="w-7 h-7 bg-emerald-500/10 text-emerald-400 rounded-full flex items-center justify-center font-bold text-xs">${idx + 1}</span>
                        <div>
                            <div class="font-bold text-sm text-slate-200">${ex.name}</div>
                            <div class="text-xs text-slate-500">${ex.cat}</div>
                        </div>
                    </div>
                `;
                results.appendChild(card);
            });

            document.getElementById('slot-actions').classList.remove('hidden');
            incrementStat('spins');
        }

        function nav(section) {
            ['slot', 'custom', 'library', 'stats', 'timer'].forEach(s => {
                document.getElementById(`sec-${s}`)?.classList.add('hidden');
                document.getElementById(`nav-${s}`)?.classList.replace('text-emerald-400', 'text-slate-400');
            });
            document.getElementById(`sec-${section}`).classList.remove('hidden');
            if(document.getElementById(`nav-${section}`)) {
                document.getElementById(`nav-${section}`).classList.replace('text-slate-400', 'text-emerald-400');
            }
        }

        function startWorkout() {
            nav('timer');
            document.getElementById('timer-mode-label').innerText = currentMode;
            document.getElementById('timer-exercise').innerText = currentWorkout[0]?.name || 'Bereit?';
        }

        function renderLibrary() {
            const list = document.getElementById('library-list');
            list.innerHTML = exercises.map(ex => `
                <div class="bg-slate-900 border border-slate-800 p-3 rounded-lg">
                    <div class="font-bold text-slate-200 text-sm">${ex.name}</div>
                    <div class="text-xs text-slate-400 mt-1">${ex.desc}</div>
                </div>
            `).join('');
        }

        function incrementStat(key) {
            let val = parseInt(localStorage.getItem(key) || '0') + 1;
            localStorage.setItem(key, val);
            loadStats();
        }

        function loadStats() {
            document.getElementById('stat-spins').innerText = localStorage.getItem('spins') || '0';
            document.getElementById('stat-completed').innerText = localStorage.getItem('completed') || '0';
        }

        window.onload = init;
    </script>
</body>
</html>
