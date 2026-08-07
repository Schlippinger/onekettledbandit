<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kettlebell Club & Workout Manager</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#f0fdf4',
                            100: '#dcfce7',
                            500: '#22c55e',
                            600: '#16a34a',
                            700: '#15803d',
                            800: '#166534',
                            900: '#14532d',
                        },
                        dark: {
                            100: '#1f2937',
                            200: '#111827',
                            300: '#0b0f19',
                        }
                    }
                }
            }
        }
    </script>
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        .slot-spin {
            animation: spinAnimation 0.5s linear infinite;
        }
        @keyframes spinAnimation {
            0% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0); }
        }
    </style>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen font-sans flex flex-col justify-between selection:bg-brand-500 selection:text-black">

    <!-- Navigation Header -->
    <header class="border-b border-slate-800 bg-slate-900/80 backdrop-blur sticky top-0 z-40">
        <div class="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="bg-brand-500 text-slate-950 p-2 rounded-xl font-black text-xl flex items-center justify-center">
                    🏋️
                </div>
                <div>
                    <h1 class="font-bold text-lg leading-tight">KB Club Manager</h1>
                    <p class="text-xs text-slate-400">Workout & Mediathek</p>
                </div>
            </div>

            <!-- Tab Buttons -->
            <nav class="hidden md:flex items-center gap-1 bg-slate-950 p-1 rounded-xl border border-slate-800 text-sm">
                <button onclick="switchTab('slotmachine')" id="tab-slotmachine" class="px-4 py-2 rounded-lg font-medium transition flex items-center gap-2 bg-brand-500 text-slate-950 font-semibold shadow">
                    <i data-lucide="dices" class="w-4 h-4"></i> Slot Machine
                </button>
                <button onclick="switchTab('create')" id="tab-create" class="px-4 py-2 rounded-lg font-medium transition flex items-center gap-2 text-slate-400 hover:text-white">
                    <i data-lucide="plus-circle" class="w-4 h-4"></i> Workout Erstellen
                </button>
                <button onclick="switchTab('saved')" id="tab-saved" class="px-4 py-2 rounded-lg font-medium transition flex items-center gap-2 text-slate-400 hover:text-white">
                    <i data-lucide="bookmark" class="w-4 h-4"></i> Gespeicherte (0)
                </button>
                <button onclick="switchTab('library')" id="tab-library" class="px-4 py-2 rounded-lg font-medium transition flex items-center gap-2 text-slate-400 hover:text-white">
                    <i data-lucide="library" class="w-4 h-4"></i> Mediathek
                </button>
                <button onclick="switchTab('stats')" id="tab-stats" class="px-4 py-2 rounded-lg font-medium transition flex items-center gap-2 text-slate-400 hover:text-white">
                    <i data-lucide="trophy" class="w-4 h-4"></i> Stats & Erfolge
                </button>
            </nav>
        </div>

        <!-- Mobile Navigation -->
        <nav class="flex md:hidden border-t border-slate-800/80 bg-slate-950/90 justify-around p-2 text-xs">
            <button onclick="switchTab('slotmachine')" id="mob-tab-slotmachine" class="flex flex-col items-center gap-1 text-brand-500 font-semibold">
                <i data-lucide="dices" class="w-5 h-5"></i> Slot
            </button>
            <button onclick="switchTab('create')" id="mob-tab-create" class="flex flex-col items-center gap-1 text-slate-400">
                <i data-lucide="plus-circle" class="w-5 h-5"></i> Neu
            </button>
            <button onclick="switchTab('saved')" id="mob-tab-saved" class="flex flex-col items-center gap-1 text-slate-400">
                <i data-lucide="bookmark" class="w-5 h-5"></i> Favoriten
            </button>
            <button onclick="switchTab('library')" id="mob-tab-library" class="flex flex-col items-center gap-1 text-slate-400">
                <i data-lucide="library" class="w-5 h-5"></i> Übungen
            </button>
            <button onclick="switchTab('stats')" id="mob-tab-stats" class="flex flex-col items-center gap-1 text-slate-400">
                <i data-lucide="trophy" class="w-5 h-5"></i> Erfolge
            </button>
        </nav>
    </header>

    <!-- Main Container -->
    <main class="max-w-6xl mx-auto px-4 py-6 flex-grow w-full">

        <!-- 1. TAB: SLOT MACHINE -->
        <section id="view-slotmachine" class="space-y-6">
            <div class="text-center max-w-xl mx-auto space-y-2">
                <h2 class="text-2xl md:text-3xl font-extrabold">Zufalls-Workout Generieren</h2>
                <p class="text-slate-400 text-sm">Lass die Slot Machine 5 zufällige Übungen für dein nächstes Workout zusammenstellen!</p>
            </div>

            <!-- Slots Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-5 gap-3" id="slots-container">
                <!-- Wird initial leer/als Platzhalter gerendert -->
            </div>

            <!-- Controls -->
            <div class="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
                <button onclick="spinSlots()" id="spin-btn" class="w-full sm:w-auto px-8 py-4 bg-brand-500 hover:bg-brand-600 active:scale-95 text-slate-950 font-black rounded-2xl shadow-lg shadow-brand-500/20 transition flex items-center justify-center gap-3 text-lg">
                    <i data-lucide="dices" class="w-6 h-6"></i> SPIN / WÜRFELN
                </button>
            </div>

            <!-- Start Configuration Card (Wird erst nach dem ersten Spin voll nutzbar) -->
            <div class="mt-8 p-6 bg-slate-900 border border-slate-800 rounded-2xl space-y-6" id="workout-config-card">
                <h3 class="text-lg font-bold flex items-center gap-2">
                    <i data-lucide="settings" class="w-5 h-5 text-brand-500"></i> Workout-Modus wählen
                </h3>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- EMOM Option -->
                    <label class="relative flex flex-col p-4 bg-slate-950 border-2 border-brand-500/40 rounded-xl cursor-pointer hover:border-brand-500 transition">
                        <div class="flex items-center justify-between mb-2">
                            <span class="font-bold text-white flex items-center gap-2">
                                <input type="radio" name="workout-mode" value="EMOM" checked class="accent-brand-500" onchange="toggleModeSelect('EMOM')">
                                EMOM (Every Minute On the Minute)
                            </span>
                            <span class="text-xs bg-brand-500/20 text-brand-500 px-2 py-0.5 rounded font-semibold">30 Min. Feste Dauer</span>
                        </div>
                        <p class="text-xs text-slate-400">Jede Minute eine neue Übung. 6 volle Runden à 5 Minuten. Perfekte Pace-Kontrolle!</p>
                    </label>

                    <!-- AMRAP Option -->
                    <label class="relative flex flex-col p-4 bg-slate-950 border-2 border-slate-800 rounded-xl cursor-pointer hover:border-brand-500 transition">
                        <div class="flex items-center justify-between mb-2">
                            <span class="font-bold text-white flex items-center gap-2">
                                <input type="radio" name="workout-mode" value="AMRAP" class="accent-brand-500" onchange="toggleModeSelect('AMRAP')">
                                AMRAP (As Many Rounds As Possible)
                            </span>
                            <span class="text-xs bg-slate-800 text-slate-300 px-2 py-0.5 rounded font-semibold">5 - 30 Min. Flexibel</span>
                        </div>
                        <p class="text-xs text-slate-400">Absolviere so viele Runden wie möglich innerhalb der gewählten Zeit.</p>
                        
                        <div id="amrap-time-select" class="mt-3 hidden">
                            <label class="text-xs text-slate-400 mb-1 block">Dauer wählen:</label>
                            <select id="amrap-minutes" class="w-full bg-slate-900 border border-slate-700 rounded-lg p-2 text-sm text-white focus:outline-none focus:border-brand-500">
                                <option value="5">5 Minuten</option>
                                <option value="10">10 Minuten</option>
                                <option value="15">15 Minuten</option>
                                <option value="20" selected>20 Minuten</option>
                                <option value="25">25 Minuten</option>
                                <option value="30">30 Minuten</option>
                            </select>
                        </div>
                    </label>
                </div>

                <div class="flex flex-col sm:flex-row gap-3 pt-2">
                    <button onclick="startWorkoutFromSlot()" id="start-slot-btn" disabled class="flex-1 py-3.5 bg-brand-500 disabled:opacity-40 disabled:cursor-not-allowed hover:bg-brand-600 text-slate-950 font-bold rounded-xl transition flex items-center justify-center gap-2">
                        <i data-lucide="play" class="w-5 h-5 fill-current"></i> Workout Jetzt Starten
                    </button>
                    <button onclick="saveCurrentSlotWorkout()" id="save-slot-btn" disabled class="px-6 py-3.5 bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed hover:bg-slate-700 text-white font-semibold rounded-xl transition flex items-center justify-center gap-2">
                        <i data-lucide="bookmark-plus" class="w-5 h-5"></i> Abspeichern
                    </button>
                </div>
            </div>
        </section>

        <!-- 2. TAB: WORKOUT ERSTELLEN -->
        <section id="view-create" class="hidden space-y-6">
            <div class="max-w-xl mx-auto space-y-2 text-center">
                <h2 class="text-2xl font-bold">Eigenes Workout Zusammenstellen</h2>
                <p class="text-slate-400 text-sm">Wähle exakt 5 Übungen aus der Mediathek für dein individuelles Training.</p>
            </div>
            
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Selection Overview -->
                <div class="lg:col-span-1 bg-slate-900 p-5 rounded-2xl border border-slate-800 space-y-4 h-fit sticky top-20">
                    <div class="flex items-center justify-between">
                        <h3 class="font-bold text-lg">Ausgewählte Übungen</h3>
                        <span id="custom-count" class="text-xs bg-brand-500/20 text-brand-500 font-bold px-2.5 py-1 rounded-full">0 / 5</span>
                    </div>
                    
                    <div id="custom-selected-list" class="space-y-2 min-h-[150px] flex flex-col justify-center text-slate-500 text-sm text-center border-2 border-dashed border-slate-800 rounded-xl p-4">
                        Klicke unten auf Übungen, um sie hinzuzufügen.
                    </div>

                    <div class="space-y-3 pt-2">
                        <input type="text" id="custom-workout-title" placeholder="Workout Name (z.B. Heavy Leg Day)" class="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2.5 text-sm text-white focus:outline-none focus:border-brand-500">
                        <button onclick="saveCustomWorkout()" id="save-custom-btn" disabled class="w-full py-3 bg-brand-500 disabled:opacity-40 hover:bg-brand-600 text-slate-950 font-bold rounded-xl transition flex items-center justify-center gap-2">
                            <i data-lucide="save" class="w-4 h-4"></i> Workout Speichern
                        </button>
                    </div>
                </div>

                <!-- Selectable Exercises -->
                <div class="lg:col-span-2 space-y-4">
                    <h3 class="font-bold text-lg">Übungsauswahl</h3>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3" id="custom-exercises-picker">
                        <!-- Dynamic content via JS -->
                    </div>
                </div>
            </div>
        </section>

        <!-- 3. TAB: GESPEICHERTE WORKOUTS -->
        <section id="view-saved" class="hidden space-y-6">
            <div class="max-w-xl mx-auto space-y-2 text-center">
                <h2 class="text-2xl font-bold">Deine Gespeicherten Workouts</h2>
                <p class="text-slate-400 text-sm">Starte deine Favoriten direkt oder passe sie an.</p>
            </div>
            
            <div id="saved-workouts-grid" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Dynamic content via JS -->
            </div>
        </section>

        <!-- 4. TAB: MEDIATHEK -->
        <section id="view-library" class="hidden space-y-6">
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 class="text-2xl font-bold">Kettlebell Mediathek</h2>
                    <p class="text-slate-400 text-sm">Alle Übungen im Überblick. Klicke auf eine Übung für Details & Wiederholungs-Anpassung.</p>
                </div>
                
                <!-- Filter Buttons -->
                <div class="flex flex-wrap gap-2" id="library-filter">
                    <button onclick="filterLibrary('ALL')" class="px-3 py-1.5 rounded-lg text-xs font-semibold bg-brand-500 text-slate-950">Alle</button>
                    <button onclick="filterLibrary('Ganzkörper')" class="px-3 py-1.5 rounded-lg text-xs font-semibold bg-slate-900 text-slate-400 hover:text-white">Ganzkörper</button>
                    <button onclick="filterLibrary('Oberkörper')" class="px-3 py-1.5 rounded-lg text-xs font-semibold bg-slate-900 text-slate-400 hover:text-white">Oberkörper</button>
                    <button onclick="filterLibrary('Unterkörper')" class="px-3 py-1.5 rounded-lg text-xs font-semibold bg-slate-900 text-slate-400 hover:text-white">Unterkörper</button>
                    <button onclick="filterLibrary('Core')" class="px-3 py-1.5 rounded-lg text-xs font-semibold bg-slate-900 text-slate-400 hover:text-white">Core</button>
                </div>
            </div>

            <!-- Library Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4" id="library-grid">
                <!-- Dynamic Content via JS -->
            </div>
        </section>

        <!-- 5. TAB: STATS & ACHIEVEMENTS -->
        <section id="view-stats" class="hidden space-y-8">
            <div class="max-w-xl mx-auto space-y-2 text-center">
                <h2 class="text-2xl font-bold">Deine Trainingsstatistik & Erfolge</h2>
                <p class="text-slate-400 text-sm">Verfolge deinen Fortschritt und schalte Achievements frei!</p>
            </div>

            <!-- Stat Summary Cards -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div class="bg-slate-900 p-4 rounded-2xl border border-slate-800 text-center">
                    <div class="text-3xl font-black text-brand-500" id="stat-total-workouts">0</div>
                    <div class="text-xs text-slate-400 mt-1">Absolvierte Workouts</div>
                </div>
                <div class="bg-slate-900 p-4 rounded-2xl border border-slate-800 text-center">
                    <div class="text-3xl font-black text-brand-500" id="stat-total-minutes">0</div>
                    <div class="text-xs text-slate-400 mt-1">Trainingsminuten</div>
                </div>
                <div class="bg-slate-900 p-4 rounded-2xl border border-slate-800 text-center">
                    <div class="text-3xl font-black text-brand-500" id="stat-total-reps">0</div>
                    <div class="text-xs text-slate-400 mt-1">Gesamt-Reps</div>
                </div>
                <div class="bg-slate-900 p-4 rounded-2xl border border-slate-800 text-center">
                    <div class="text-3xl font-black text-brand-500" id="stat-streak">0 Tage</div>
                    <div class="text-xs text-slate-400 mt-1">Aktueller Streak</div>
                </div>
            </div>

            <!-- Achievements Section (Vorbereitet für ~50 Badges) -->
            <div class="space-y-4">
                <div class="flex items-center justify-between">
                    <h3 class="font-bold text-lg flex items-center gap-2">
                        <i data-lucide="award" class="w-5 h-5 text-brand-500"></i> Erfolge & Badges 
                        <span class="text-xs bg-slate-800 text-slate-400 px-2 py-0.5 rounded-full" id="achievement-progress-text">0 / 6 freigeschaltet</span>
                    </h3>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4" id="achievements-grid">
                    <!-- Dynamic Badges rendered via JS -->
                </div>
            </div>
        </section>

    </main>

    <!-- LIVE WORKOUT SCREEN (MODAL / OVERLAY) -->
    <div id="workout-modal" class="fixed inset-0 bg-slate-950 z-50 hidden flex flex-col justify-between p-4 md:p-8">
        <!-- Top Header Controls -->
        <div class="flex items-center justify-between border-b border-slate-800 pb-4">
            <div class="flex items-center gap-3">
                <span id="live-mode-badge" class="px-3 py-1 bg-brand-500 text-slate-950 font-black text-xs rounded-full uppercase tracking-wider">EMOM</span>
                <h3 id="live-workout-title" class="font-bold text-slate-200">Kettlebell Workout</h3>
            </div>
            <!-- Wake Lock Status Indicator -->
            <div class="flex items-center gap-2">
                <span id="wake-lock-status" class="text-xs text-brand-500 flex items-center gap-1 bg-brand-500/10 px-2.5 py-1 rounded-full border border-brand-500/20">
                    <i data-lucide="sun" class="w-3.5 h-3.5"></i> Display aktiv
                </span>
                <button onclick="confirmExitWorkout()" class="p-2 text-slate-400 hover:text-white bg-slate-900 rounded-xl">
                    <i data-lucide="x" class="w-6 h-6"></i>
                </button>
            </div>
        </div>

        <!-- Center Content: Main Timer & Current Exercise -->
        <div class="max-w-2xl mx-auto w-full text-center space-y-6 my-auto py-4">
            
            <!-- Big Timer -->
            <div class="space-y-1">
                <div id="live-timer" class="text-6xl md:text-8xl font-black font-mono text-white tracking-tight">01:00</div>
                <div class="text-sm text-slate-400 font-semibold" id="live-round-info">Runde 1 von 6 (Min 1 / 30)</div>
            </div>

            <!-- Current Exercise Card -->
            <div class="bg-slate-900 border-2 border-brand-500 rounded-3xl p-6 shadow-2xl shadow-brand-500/10 space-y-4">
                <div class="flex justify-between items-center text-xs font-bold text-brand-500">
                    <span id="live-ex-category">GANZKÖRPER</span>
                    <span id="live-ex-reps" class="bg-brand-500/20 px-3 py-1 rounded-full">15 REPS</span>
                </div>

                <div class="text-6xl my-2" id="live-ex-icon">🏋️</div>

                <h2 id="live-ex-title" class="text-2xl md:text-3xl font-black text-white">Kettlebell Swing</h2>
                <p id="live-ex-desc" class="text-slate-400 text-sm max-w-md mx-auto">Dynamische Hüftstreckung aus der Kniebeuge, Kettlebell schwingt auf Brusthöhe.</p>
            </div>

            <!-- Up Next Bar -->
            <div class="bg-slate-900/60 border border-slate-800 rounded-xl p-3 flex items-center justify-between text-sm">
                <span class="text-slate-400 text-xs font-medium">Als Nächstes:</span>
                <span id="live-next-ex" class="font-bold text-slate-200">Goblet Squat (12 Reps)</span>
            </div>
        </div>

        <!-- Bottom Controls -->
        <div class="max-w-md mx-auto w-full flex items-center justify-center gap-4 pt-2">
            <button onclick="togglePauseWorkout()" id="pause-btn" class="flex-1 py-4 bg-brand-500 text-slate-950 font-black rounded-2xl shadow-lg flex items-center justify-center gap-2 text-lg">
                <i data-lucide="pause" class="w-6 h-6 fill-current"></i> Pause
            </button>
            <button onclick="skipExercise()" class="p-4 bg-slate-900 hover:bg-slate-800 text-slate-300 font-bold rounded-2xl border border-slate-800">
                <i data-lucide="skip-forward" class="w-6 h-6"></i>
            </button>
        </div>
    </div>

    <!-- EXERCISE DETAIL MODAL (Mediathek / Klick-Details) -->
    <div id="exercise-detail-modal" class="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-50 hidden flex items-center justify-center p-4">
        <div class="bg-slate-900 border border-slate-800 w-full max-w-md rounded-3xl p-6 space-y-6 shadow-2xl relative">
            <button onclick="closeExerciseModal()" class="absolute top-4 right-4 p-2 text-slate-400 hover:text-white bg-slate-950 rounded-full border border-slate-800">
                <i data-lucide="x" class="w-5 h-5"></i>
            </button>

            <div class="text-center space-y-2">
                <div id="modal-ex-icon" class="text-6xl mb-2">🏋️</div>
                <h3 id="modal-ex-title" class="text-2xl font-black text-white">Übungsname</h3>
                <div class="flex items-center justify-center gap-2">
                    <span id="modal-ex-level" class="text-xs bg-slate-800 text-slate-300 font-semibold px-2.5 py-1 rounded-full">Anfänger</span>
                    <span id="modal-ex-category" class="text-xs bg-brand-500/20 text-brand-500 font-bold px-2.5 py-1 rounded-full">Ganzkörper</span>
                </div>
            </div>

            <p id="modal-ex-desc" class="text-slate-300 text-sm leading-relaxed text-center">
                Detaillierte Beschreibung der Übungsausführung und Worauf geachtet werden muss.
            </p>

            <!-- Reps Customization -->
            <div class="bg-slate-950 p-4 rounded-2xl border border-slate-800 space-y-2">
                <label class="text-xs font-bold text-slate-400 block text-center uppercase tracking-wider">Standard Wiederholungen (Reps)</label>
                <div class="flex items-center justify-center gap-4">
                    <button onclick="adjustModalReps(-1)" class="w-10 h-10 bg-slate-900 hover:bg-slate-800 text-white font-bold rounded-xl border border-slate-800 flex items-center justify-center text-xl active:scale-95 transition">-</button>
                    <input type="number" id="modal-ex-reps-input" class="w-20 bg-slate-900 border border-slate-700 rounded-xl py-2 text-center text-xl font-bold text-brand-500 focus:outline-none focus:border-brand-500" value="15" min="1" max="100">
                    <button onclick="adjustModalReps(1)" class="w-10 h-10 bg-slate-900 hover:bg-slate-800 text-white font-bold rounded-xl border border-slate-800 flex items-center justify-center text-xl active:scale-95 transition">+</button>
                </div>
            </div>

            <button onclick="saveModalReps()" class="w-full py-3.5 bg-brand-500 hover:bg-brand-600 text-slate-950 font-bold rounded-xl transition">
                Speichern & Schließen
            </button>
        </div>
    </div>

    <!-- Application JavaScript Logic -->
    <script>
        // --- DATA & EXERCISES DATABASE ---
        let exercises = [
            { id: '1', name: 'Kettlebell Swing', category: 'Ganzkörper', level: 'Anfänger', reps: 15, icon: '🔄', desc: 'Explosiver Hüftstoß aus der Beuge. Stärkt den gesamten hinteren Bewegungsapparat.' },
            { id: '2', name: 'Goblet Squat', category: 'Unterkörper', level: 'Anfänger', reps: 12, icon: '🦵', desc: 'Kniebeuge mit vor der Brust gehaltener Kettlebell. Tiefe Hocke bei geradem Rücken.' },
            { id: '3', name: 'Single-Arm Clean', category: 'Oberkörper', level: 'Fortgeschritten', reps: 10, icon: '🏋️', desc: 'Kettlebell flüssig aus den Beinen auf Brusthöhe (Rack-Position) umsetzen.' },
            { id: '4', name: 'Strict Overhead Press', category: 'Oberkörper', level: 'Fortgeschritten', reps: 8, icon: '⬆️', desc: 'Sauberes Drücken der Kettlebell aus der Rack-Position über den Kopf ohne Schwung.' },
            { id: '5', name: 'Russian Twist', category: 'Core', level: 'Anfänger', reps: 20, icon: '🔄', desc: 'Sitzen mit leicht angehobenen Beinen, Kettlebell kontrolliert von Seite zu Seite führen.' },
            { id: '6', name: 'Kettlebell Snatch', category: 'Ganzkörper', level: 'Experte', reps: 8, icon: '⚡', desc: 'In einer einzigen explosiven Bewegung von unten direkt über den Kopf führen.' },
            { id: '7', name: 'Turkish Get-Up', category: 'Ganzkörper', level: 'Experte', reps: 4, icon: '🧘', desc: 'Vom Liegen bis zum Stand aufstehen, während die Kettlebell oben gehalten wird.' },
            { id: '8', name: 'Sumo Deadlift High Pull', category: 'Ganzkörper', level: 'Fortgeschritten', reps: 12, icon: '📐', desc: 'Breiter Stand, Kreuzheben mit anschließendm hohem Ziehen der Ellbogen.' },
            { id: '9', name: 'Windmill', category: 'Core', level: 'Fortgeschritten', reps: 6, icon: '💨', desc: 'Kettlebell oben halten und den Oberkörper seitlich zum Boden neigen.' },
            { id: '10', name: 'Kettlebell Lunge', category: 'Unterkörper', level: 'Anfänger', reps: 10, icon: '🚶', desc: 'Ausfallschritte nach vorne oder hinten mit Kettlebell in Goblet- oder Rack-Haltung.' }
        ];

        // Achievements Database (Erweiterbar bis 50+)
        let achievements = [
            { id: 'first_step', title: 'Erster Schritt', desc: 'Absolviere dein erstes Workout', icon: '🥇', unlocked: false },
            { id: 'streak_3', title: 'Streak Starter', desc: 'Trainiere 3 Tage in Folge', icon: '🔥', unlocked: false },
            { id: 'amrap_5', title: 'AMRAP Beaster', desc: 'Schließe 5 AMRAP Workouts ab', icon: '⏱️', unlocked: false },
            { id: 'emom_master', title: 'EMOM Titan', desc: 'Schließe ein 30-Minuten EMOM ab', icon: '⌛', unlocked: false },
            { id: 'reps_1000', title: '1.000 Rep Club', desc: 'Absolviere insgesamt 1.000 Wiederholungen', icon: '💪', unlocked: false },
            { id: 'slot_spinner', title: 'Glücksritter', desc: 'Nutze die Slot Machine 10 Mal', icon: '🎰', unlocked: false }
        ];

        // User Stats
        let userStats = {
            totalWorkouts: 0,
            totalMinutes: 0,
            totalReps: 0,
            streakDays: 0,
            spinCount: 0
        };

        // State Variables
        let currentSlotExercises = [];
        let customSelectedExercises = [];
        let savedWorkouts = [];
        let currentActiveWorkout = null;
        let selectedExForModal = null;

        // Timer State Variables
        let timerInterval = null;
        let timerSecondsLeft = 60;
        let currentRound = 1;
        let totalRounds = 6;
        let currentExIndex = 0;
        let isPaused = false;
        let wakeLock = null;

        // Init App
        window.addEventListener('DOMContentLoaded', () => {
            lucide.createIcons();
            renderEmptySlots();
            renderCustomPicker();
            renderLibrary();
            renderAchievements();
            updateStatsUI();
        });

        // --- NAVIGATION TABS ---
        function switchTab(tabId) {
            ['slotmachine', 'create', 'saved', 'library', 'stats'].forEach(id => {
                document.getElementById(`view-${id}`).classList.add('hidden');
                
                const btn = document.getElementById(`tab-${id}`);
                const mobBtn = document.getElementById(`mob-tab-${id}`);
                
                if(btn) btn.className = "px-4 py-2 rounded-lg font-medium transition flex items-center gap-2 text-slate-400 hover:text-white";
                if(mobBtn) mobBtn.className = "flex flex-col items-center gap-1 text-slate-400";
            });

            document.getElementById(`view-${tabId}`).classList.remove('hidden');
            
            const activeBtn = document.getElementById(`tab-${tabId}`);
            const activeMobBtn = document.getElementById(`mob-tab-${tabId}`);
            
            if(activeBtn) activeBtn.className = "px-4 py-2 rounded-lg font-medium transition flex items-center gap-2 bg-brand-500 text-slate-950 font-semibold shadow";
            if(activeMobBtn) activeMobBtn.className = "flex flex-col items-center gap-1 text-brand-500 font-semibold";
        }

        // --- 1. SLOT MACHINE LOGIC ---
        function renderEmptySlots() {
            const container = document.getElementById('slots-container');
            container.innerHTML = '';
            for(let i = 0; i < 5; i++) {
                container.innerHTML += `
                    <div class="bg-slate-900 border border-slate-800 border-dashed rounded-2xl p-4 flex flex-col items-center justify-center min-h-[160px] text-center">
                        <span class="text-3xl text-slate-700 mb-2">❓</span>
                        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Slot ${i+1}</span>
                        <span class="text-xs text-slate-600 mt-1">Noch nicht gewürfelt</span>
                    </div>
                `;
            }
        }

        function spinSlots() {
            userStats.spinCount++;
            if(userStats.spinCount >= 10) unlockAchievement('slot_spinner');

            const container = document.getElementById('slots-container');
            container.innerHTML = '';

            // Random selection of 5 unique exercises
            let shuffled = [...exercises].sort(() => 0.5 - Math.random());
            currentSlotExercises = shuffled.slice(0, 5);

            currentSlotExercises.forEach((ex, idx) => {
                container.innerHTML += `
                    <div class="bg-slate-900 border border-slate-800 rounded-2xl p-4 flex flex-col justify-between min-h-[160px] slot-spin shadow-lg">
                        <div class="flex justify-between items-center text-xs text-slate-400">
                            <span>Slot ${idx+1}</span>
                            <span class="font-bold text-brand-500">${ex.reps} Reps</span>
                        </div>
                        <div class="text-center my-2">
                            <span class="text-3xl">${ex.icon}</span>
                            <h4 class="font-bold text-sm text-white mt-1 leading-tight">${ex.name}</h4>
                        </div>
                        <span class="text-[10px] text-center bg-slate-950 text-slate-400 py-1 rounded-md border border-slate-800">${ex.category}</span>
                    </div>
                `;
            });

            // Enable action buttons
            document.getElementById('start-slot-btn').disabled = false;
            document.getElementById('save-slot-btn').disabled = false;
        }

        function toggleModeSelect(mode) {
            const amrapSelect = document.getElementById('amrap-time-select');
            if(mode === 'AMRAP') {
                amrapSelect.classList.remove('hidden');
            } else {
                amrapSelect.classList.add('hidden');
            }
        }

        // --- 2. MEDIATHEK & DETAIL MODAL LOGIC ---
        function renderLibrary(filterCategory = 'ALL') {
            const grid = document.getElementById('library-grid');
            grid.innerHTML = '';

            const filtered = filterCategory === 'ALL' ? exercises : exercises.filter(e => e.category === filterCategory);

            filtered.forEach(ex => {
                grid.innerHTML += `
                    <div onclick="openExerciseModal('${ex.id}')" class="bg-slate-900 border border-slate-800 hover:border-brand-500/50 p-4 rounded-2xl cursor-pointer transition hover:scale-[1.02] flex flex-col justify-between gap-3 group">
                        <div class="flex justify-between items-start">
                            <span class="text-3xl group-hover:scale-110 transition">${ex.icon}</span>
                            <span class="text-xs bg-brand-500/10 text-brand-500 border border-brand-500/20 font-bold px-2 py-0.5 rounded-full">${ex.reps} Reps</span>
                        </div>
                        <div>
                            <h4 class="font-bold text-white text-base">${ex.name}</h4>
                            <p class="text-xs text-slate-400 line-clamp-2 mt-1">${ex.desc}</p>
                        </div>
                        <div class="flex justify-between items-center text-[10px] text-slate-400 pt-2 border-t border-slate-800/80">
                            <span>${ex.category}</span>
                            <span class="text-slate-400">${ex.level}</span>
                        </div>
                    </div>
                `;
            });
        }

        function filterLibrary(cat) {
            renderLibrary(cat);
        }

        function openExerciseModal(id) {
            selectedExForModal = exercises.find(e => e.id === id);
            if(!selectedExForModal) return;

            document.getElementById('modal-ex-icon').innerText = selectedExForModal.icon;
            document.getElementById('modal-ex-title').innerText = selectedExForModal.name;
            document.getElementById('modal-ex-category').innerText = selectedExForModal.category;
            document.getElementById('modal-ex-level').innerText = selectedExForModal.level;
            document.getElementById('modal-ex-desc').innerText = selectedExForModal.desc;
            document.getElementById('modal-ex-reps-input').value = selectedExForModal.reps;

            document.getElementById('exercise-detail-modal').classList.remove('hidden');
        }

        function closeExerciseModal() {
            document.getElementById('exercise-detail-modal').classList.add('hidden');
        }

        function adjustModalReps(delta) {
            const input = document.getElementById('modal-ex-reps-input');
            let val = parseInt(input.value) || 0;
            val = Math.max(1, val + delta);
            input.value = val;
        }

        function saveModalReps() {
            if(selectedExForModal) {
                const newVal = parseInt(document.getElementById('modal-ex-reps-input').value);
                if(newVal > 0) {
                    selectedExForModal.reps = newVal;
                    renderLibrary();
                    renderCustomPicker();
                }
            }
            closeExerciseModal();
        }

        // --- 3. CUSTOM WORKOUT BUILDER ---
        function renderCustomPicker() {
            const picker = document.getElementById('custom-exercises-picker');
            picker.innerHTML = '';

            exercises.forEach(ex => {
                const isSelected = customSelectedExercises.some(item => item.id === ex.id);
                picker.innerHTML += `
                    <div onclick="toggleSelectCustom('${ex.id}')" class="p-3 bg-slate-900 border ${isSelected ? 'border-brand-500 bg-brand-500/10' : 'border-slate-800'} rounded-xl cursor-pointer transition flex items-center gap-3">
                        <span class="text-2xl">${ex.icon}</span>
                        <div class="flex-1 min-w-0">
                            <h5 class="text-sm font-bold text-white truncate">${ex.name}</h5>
                            <span class="text-xs text-slate-400">${ex.reps} Reps • ${ex.category}</span>
                        </div>
                        <i data-lucide="${isSelected ? 'check-circle-2' : 'plus'}" class="w-5 h-5 ${isSelected ? 'text-brand-500' : 'text-slate-500'}"></i>
                    </div>
                `;
            });
            lucide.createIcons();
        }

        function toggleSelectCustom(id) {
            const index = customSelectedExercises.findIndex(e => e.id === id);
            if(index > -1) {
                customSelectedExercises.splice(index, 1);
            } else {
                if(customSelectedExercises.length >= 5) {
                    alert('Du kannst maximal 5 Übungen auswählen.');
                    return;
                }
                const ex = exercises.find(e => e.id === id);
                customSelectedExercises.push(ex);
            }
            updateCustomSelectedUI();
            renderCustomPicker();
        }

        function updateCustomSelectedUI() {
            const list = document.getElementById('custom-selected-list');
            document.getElementById('custom-count').innerText = `${customSelectedExercises.length} / 5`;

            if(customSelectedExercises.length === 0) {
                list.className = "space-y-2 min-h-[150px] flex flex-col justify-center text-slate-500 text-sm text-center border-2 border-dashed border-slate-800 rounded-xl p-4";
                list.innerText = "Klicke rechts auf Übungen, um sie hinzuzufügen.";
                document.getElementById('save-custom-btn').disabled = true;
                return;
            }

            list.className = "space-y-2 min-h-[150px]";
            list.innerHTML = '';
            customSelectedExercises.forEach((ex, i) => {
                list.innerHTML += `
                    <div class="flex items-center justify-between p-2 bg-slate-950 border border-slate-800 rounded-lg text-xs">
                        <span class="font-bold text-slate-200">${i+1}. ${ex.name}</span>
                        <span class="text-brand-500 font-semibold">${ex.reps} Reps</span>
                    </div>
                `;
            });

            document.getElementById('save-custom-btn').disabled = customSelectedExercises.length !== 5;
        }

        function saveCustomWorkout() {
            const titleInput = document.getElementById('custom-workout-title');
            const title = titleInput.value.trim() || `Workout #${savedWorkouts.length + 1}`;

            savedWorkouts.push({
                id: Date.now().toString(),
                title: title,
                exercises: [...customSelectedExercises]
            });

            titleInput.value = '';
            customSelectedExercises = [];
            updateCustomSelectedUI();
            renderCustomPicker();
            renderSavedWorkouts();
            updateSavedTabBadge();
            alert('Workout erfolgreich gespeichert!');
        }

        function saveCurrentSlotWorkout() {
            if(currentSlotExercises.length === 0) return;
            savedWorkouts.push({
                id: Date.now().toString(),
                title: `Zufalls-Workout #${savedWorkouts.length + 1}`,
                exercises: [...currentSlotExercises]
            });
            renderSavedWorkouts();
            updateSavedTabBadge();
            alert('Slot Machine Workout abgespeichert!');
        }

        // --- 4. SAVED WORKOUTS LOGIC ---
        function renderSavedWorkouts() {
            const grid = document.getElementById('saved-workouts-grid');
            grid.innerHTML = '';

            if(savedWorkouts.length === 0) {
                grid.innerHTML = `
                    <div class="col-span-full py-12 text-center text-slate-500 space-y-2">
                        <i data-lucide="bookmark-x" class="w-10 h-10 mx-auto text-slate-600"></i>
                        <p>Noch keine gespeicherten Workouts vorhanden.</p>
                    </div>
                `;
                lucide.createIcons();
                return;
            }

            savedWorkouts.forEach((w) => {
                grid.innerHTML += `
                    <div class="bg-slate-900 border border-slate-800 p-5 rounded-2xl space-y-4">
                        <div class="flex justify-between items-start">
                            <h4 class="font-bold text-lg text-white">${w.title}</h4>
                            <button onclick="deleteSavedWorkout('${w.id}')" class="text-slate-500 hover:text-red-400 p-1">
                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                            </button>
                        </div>

                        <div class="space-y-1.5">
                            ${w.exercises.map((ex, i) => `
                                <div class="flex justify-between text-xs text-slate-300 bg-slate-950 px-3 py-1.5 rounded-lg border border-slate-800/60">
                                    <span>${i+1}. ${ex.name}</span>
                                    <span class="text-brand-500 font-bold">${ex.reps} Reps</span>
                                </div>
                            `).join('')}
                        </div>

                        <button onclick="startWorkoutObj('${w.id}')" class="w-full py-3 bg-brand-500 hover:bg-brand-600 text-slate-950 font-bold rounded-xl transition flex items-center justify-center gap-2 text-sm">
                            <i data-lucide="play" class="w-4 h-4 fill-current"></i> Jetzt Starten
                        </button>
                    </div>
                `;
            });
            lucide.createIcons();
        }

        function updateSavedTabBadge() {
            document.getElementById('tab-saved').innerText = `Gespeicherte (${savedWorkouts.length})`;
        }

        function deleteSavedWorkout(id) {
            savedWorkouts = savedWorkouts.filter(w => w.id !== id);
            renderSavedWorkouts();
            updateSavedTabBadge();
        }

        // --- 5. LIVE WORKOUT TIMER & WAKE LOCK ENGINE ---
        
        // Request Screen Wake Lock (Bildschirm anlassen)
        async function requestWakeLock() {
            try {
                if ('wakeLock' in navigator) {
                    wakeLock = await navigator.wakeLock.request('screen');
                    document.getElementById('wake-lock-status').classList.remove('hidden');
                }
            } catch (err) {
                console.warn(`Wake Lock konnte nicht aktiviert werden: ${err.message}`);
                document.getElementById('wake-lock-status').classList.add('hidden');
            }
        }

        function releaseWakeLock() {
            if (wakeLock !== null) {
                wakeLock.release().then(() => {
                    wakeLock = null;
                });
            }
        }

        function startWorkoutFromSlot() {
            if(currentSlotExercises.length < 5) return;
            const mode = document.querySelector('input[name="workout-mode"]:checked').value;
            const amrapMins = parseInt(document.getElementById('amrap-minutes').value) || 20;

            initLiveWorkout({
                title: 'Slot Machine Workout',
                mode: mode,
                durationMinutes: mode === 'EMOM' ? 30 : amrapMins,
                exercises: currentSlotExercises
            });
        }

        function startWorkoutObj(id) {
            const w = savedWorkouts.find(item => item.id === id);
            if(!w) return;

            // Standardmäßig als EMOM starten
            initLiveWorkout({
                title: w.title,
                mode: 'EMOM',
                durationMinutes: 30,
                exercises: w.exercises
            });
        }

        function initLiveWorkout(config) {
            currentActiveWorkout = config;
            currentExIndex = 0;
            currentRound = 1;
            isPaused = false;

            document.getElementById('live-workout-title').innerText = config.title;
            document.getElementById('live-mode-badge').innerText = config.mode;

            if(config.mode === 'EMOM') {
                totalRounds = 6; // 6 Runden à 5 Minuten = 30 Min
                timerSecondsLeft = 60;
            } else { // AMRAP
                totalRounds = 1;
                timerSecondsLeft = config.durationMinutes * 60;
            }

            updateLiveUI();
            document.getElementById('workout-modal').classList.remove('hidden');
            
            // Aktivieren des Wake Locks
            requestWakeLock();

            startTimer();
        }

        function startTimer() {
            clearInterval(timerInterval);
            timerInterval = setInterval(() => {
                if(isPaused) return;

                timerSecondsLeft--;

                if(currentActiveWorkout.mode === 'EMOM') {
                    if(timerSecondsLeft <= 0) {
                        // Nächste Minute / Übung
                        timerSecondsLeft = 60;
                        currentExIndex++;
                        if(currentExIndex >= currentActiveWorkout.exercises.length) {
                            currentExIndex = 0;
                            currentRound++;
                        }

                        if(currentRound > totalRounds) {
                            completeWorkout();
                            return;
                        }
                    }
                } else { // AMRAP
                    if(timerSecondsLeft <= 0) {
                        completeWorkout();
                        return;
                    }
                }

                updateLiveUI();
            }, 1000);
        }

        function updateLiveUI() {
            // Format mm:ss
            const mins = Math.floor(timerSecondsLeft / 60);
            const secs = timerSecondsLeft % 60;
            document.getElementById('live-timer').innerText = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;

            const currentEx = currentActiveWorkout.exercises[currentExIndex];
            const nextExIndex = (currentExIndex + 1) % currentActiveWorkout.exercises.length;
            const nextEx = currentActiveWorkout.exercises[nextExIndex];

            if(currentActiveWorkout.mode === 'EMOM') {
                const currentMinuteTotal = ((currentRound - 1) * 5) + (currentExIndex + 1);
                document.getElementById('live-round-info').innerText = `Runde ${currentRound} von ${totalRounds} (Min. ${currentMinuteTotal} / 30)`;
            } else {
                document.getElementById('live-round-info').innerText = `AMRAP Zirkel • Durchgang ${currentRound}`;
            }

            document.getElementById('live-ex-category').innerText = currentEx.category.toUpperCase();
            document.getElementById('live-ex-reps').innerText = `${currentEx.reps} REPS`;
            document.getElementById('live-ex-icon').innerText = currentEx.icon;
            document.getElementById('live-ex-title').innerText = currentEx.name;
            document.getElementById('live-ex-desc').innerText = currentEx.desc;

            document.getElementById('live-next-ex').innerText = `${nextEx.name} (${nextEx.reps} Reps)`;
        }

        function togglePauseWorkout() {
            isPaused = !isPaused;
            const btn = document.getElementById('pause-btn');
            if(isPaused) {
                btn.innerHTML = `<i data-lucide="play" class="w-6 h-6 fill-current"></i> Weiter`;
            } else {
                btn.innerHTML = `<i data-lucide="pause" class="w-6 h-6 fill-current"></i> Pause`;
            }
            lucide.createIcons();
        }

        function skipExercise() {
            currentExIndex = (currentExIndex + 1) % currentActiveWorkout.exercises.length;
            if(currentActiveWorkout.mode === 'EMOM') {
                timerSecondsLeft = 60;
            }
            updateLiveUI();
        }

        function confirmExitWorkout() {
            if(confirm("Möchtest du das aktuelle Workout wirklich abbrechen?")) {
                closeWorkoutModal();
            }
        }

        function completeWorkout() {
            clearInterval(timerInterval);
            releaseWakeLock();
            
            // Statistics Update
            userStats.totalWorkouts++;
            userStats.totalMinutes += currentActiveWorkout.durationMinutes;
            
            // Sum reps for the workout
            let repsInWorkout = currentActiveWorkout.exercises.reduce((acc, curr) => acc + curr.reps, 0);
            if(currentActiveWorkout.mode === 'EMOM') repsInWorkout *= 6;
            userStats.totalReps += repsInWorkout;

            // Check Achievements
            if(userStats.totalWorkouts >= 1) unlockAchievement('first_step');
            if(userStats.totalReps >= 1000) unlockAchievement('reps_1000');
            if(currentActiveWorkout.mode === 'EMOM') unlockAchievement('emom_master');

            updateStatsUI();
            alert("🎉 Hervorragende Leistung! Workout erfolgreich abgeschlossen!");
            closeWorkoutModal();
        }

        function closeWorkoutModal() {
            clearInterval(timerInterval);
            releaseWakeLock();
            document.getElementById('workout-modal').classList.add('hidden');
        }

        // --- 6. STATS & ACHIEVEMENTS ENGINE ---
        function updateStatsUI() {
            document.getElementById('stat-total-workouts').innerText = userStats.totalWorkouts;
            document.getElementById('stat-total-minutes').innerText = userStats.totalMinutes;
            document.getElementById('stat-total-reps').innerText = userStats.totalReps;
            document.getElementById('stat-streak').innerText = `${userStats.streakDays} Tage`;

            renderAchievements();
        }

        function renderAchievements() {
            const grid = document.getElementById('achievements-grid');
            grid.innerHTML = '';

            const unlockedCount = achievements.filter(a => a.unlocked).length;
            document.getElementById('achievement-progress-text').innerText = `${unlockedCount} / ${achievements.length} freigeschaltet`;

            achievements.forEach(ach => {
                grid.innerHTML += `
                    <div class="p-4 rounded-2xl border ${ach.unlocked ? 'bg-brand-500/10 border-brand-500/40' : 'bg-slate-900/40 border-slate-800 opacity-50'} flex items-center gap-4">
                        <span class="text-3xl">${ach.icon}</span>
                        <div>
                            <h4 class="font-bold text-sm ${ach.unlocked ? 'text-white' : 'text-slate-400'}">${ach.title}</h4>
                            <p class="text-xs text-slate-500">${ach.desc}</p>
                        </div>
                    </div>
                `;
            });
        }

        function unlockAchievement(id) {
            const ach = achievements.find(a => a.id === id);
            if(ach && !ach.unlocked) {
                ach.unlocked = true;
                renderAchievements();
            }
        }
    </script>
</body>
</html>
