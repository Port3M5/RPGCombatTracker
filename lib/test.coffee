# Create Creatures
arrario = new PC "Arrario", 15
rats = (new NPC "Rat #{num}", 2, 6 for num in [1..3])

# Create the tracker
tracker = new Tracker

# Add the creatures to the tracker
tracker.add_creature arrario
for rat in rats
  tracker.add_creature rat

# Start the encounter
tracker.start_encounter()

# Creare timers and add them to creatures
timer = new Timer "Hello", 1
arrario.add_event timer

timer = new Ticker "Poison", 2
timer.set_description "Take 2d4 con damage"
tracker.find_creature("Rat 1").add_event timer

# Advance some steps
for num in [1..10]
  tracker.next()

# Harm Rat 2
tracker.find_creature("Rat 2").harm(3)

tracker.next()

# Kill Rat 2
tracker.kill_creature tracker.find_creature("Rat 2")
console.log tracker.draw()

delayed = tracker.next()
tracker.delay_creature delayed
tracker.next()

console.log tracker.draw()

tracker.undelay_creature delayed

console.log tracker.draw()