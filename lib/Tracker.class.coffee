root = exports ? this
class root.Tracker
  creatures: []
  started: no
  round: 0
  part:0
  
  constructor: ->
    console.log "Creating tracker object"
    
  add_creature: (creature) ->
    console.log "Adding #{creature.name} to tracker"
    @creatures.push creature
  
  draw: ->
    console.log "Drawing the tracker"
    @toString()
    
  get_current_creature: ->
    console.log "Getting current creature"
    
    current = @get_creatures()[@part]
    return current
    
  kill_creature: (creature) ->
    console.log "Killing #{creature.name}"
    for num in @creatures
      if num is creature
        @creatures.splice _i, 1
        @tick()
  
  delay_creature: (creature) ->
    console.log "Delaying #{creature.name}"
    creature.delayed = yes
    @tick()
    
  get_delayed_creatures: ->
    delayed = []
    for creature in @creatures
      if creature.is_delayed()
        delayed.push creature
    return delayed
    
  get_creatures: ->
    undelayed = []
    for creature in @creatures
      if not creature.is_delayed()
        undelayed.push creature
    return undelayed
    
  undelay_creature: (creature) ->
    console.log "Undelaying #{creature.name} and changing initiative"
    for num in @creatures
      if num is creature and creature.is_delayed()
        creature.initiative = @get_creatures()[@part].initiative - 1
        creature.delayed = no
        @sort_by_initiative()
  
  compare_initiatives: (a, b) ->
    b.initiative - a.initiative
  
  sort_by_initiative: ->
    console.log "Sorting creatures by initiative"
    @creatures.sort(@compare_initiatives)
  
  find_creature: (name) ->
    console.log "Finding #{name}"
    for creature in @creatures
      if creature.name is name and creature instanceof Creature
        return creature
  
  start_encounter: ->
    if not @started
      console.log "Starting the encounter"
      @sort_by_initiative()
      @round = 1
      @started = yes
      @tick()
  
  next: ->
    console.log "Going to the next creature"
    @part = (@part + 1) % @get_creatures().length
    @round++ if @part is 0
    
    @tick()
  
  tick: ->
    console.log "Round #{@round} part #{@part}. #{@get_current_creature().name} to go."
    creature = @get_current_creature()
    creature.tick()
    return creature
    
  toString: ->
    """
    <div id="tracker" data-round="#{@round}">
      <header>
        <hgroup>
          <h1>Round #{@round}</h1>
        </hgroup>
      </header>
      <div class="creatures">
        #{creature for creature in @get_creatures()}
      </div>
      <div class="creatures delayed">
        #{creature for creature in @get_delayed_creatures()}
      </div>
      <div class="clear"></div>
    </div>
    """