"use strict"
root = exports ? this
###
Creature

The Base class for PC's and NPC's. Stores data such as the name, initiative and if it's delayed. Also contains an array of events that are currently in effect for the creature
###
class root.Creature
  name: null
  initiative: null
  delayed: no
  events: []
  
  ###
  constructor(name)
  params:
    name: a String that represents the creature
  returns: This Creature
  
  Creates a new creature and assigns the name to the attribute name
  ###
  constructor: (@name) ->
    console.log "Creating Creature called #{@name}"
    return @
  
  ###
  add_event(event)
  params:
    event: an Event Object
  returns: This Creature
  
  Adds the given event to the events attribute
  ###
  add_event: (event) ->
    console.log "Adding event #{event.name} to #{@name}"
    @events.push event
    return @
  
  ###
  is_delayed()
  returns: boolean
  
  If the creature is delayed returns true
  ###
  is_delayed: ->
    return @delayed
  
  ###
  set_initiative(initiative)
  params:
    initiative: an integer
  returns: This Creature
  
  sets the initiative to the given number.
  Useful if the creature has been delayed and needs to have its initiative changed to reflect this.
  ###
  set_initiative: (@initiative) ->
    console.log "Setting #{@name}'s initiative to #{@initiative}"
    return @
  
  ###
  roll_initiative(modifier)
  params:
    modifier: an integer
  returns: This Creature
  
  Rolls the initiative based on the modifier and stores it.
  ###
  roll_initiative: (modifier) ->
    console.log "Rolling the initiative of #{@name} with a modifier of #{modifier}"
    roll = new Dice "d20+#{modifier}", 0
    @initiative = roll.result
    return @
  
  ###
  tick()
  returns: This Creature
  
  Triggers any events that is attached to the creature and removes any that should not exist anymore.
  ###
  tick: ->
    for event in @events
      if event instanceof Event
        event.tick()
        if event.time is 0
          @events.splice _i, 1
    return @
  
  ###
  toString()
  returns: a HTML string representation of this creature
  ###
  toString: ->
    """
    <div class="creature" data-name="#{@name}" data-initiative="#{@initiative}">
      <header>
        <hgroup>
          <h1>#{@name}</h1>
          <h2>Initiative #{@initiative}</h2>
        </hgroup>
      </header>
      #{event for event in @events}
      <footer>
        #{if @delayed then "<a class='undelay' href='#' data-name='#{@name}'>Undelay</a>" else ''}
        <a href="#" class="kill">Kill</a>
      </footer>
    </div>
    """

###
PC

This class contains anything that is specific to PC's
###
class root.PC extends root.Creature
  
  ###
  constructor(name, initiative)
  params:
    name: a String to represent the PC
    initiative: the Initiative the Player Rolled
  returns: this PC
  
  Creates a new Instance of the PC class and gives it a name and initiative
  ###
  constructor: (@name, @initiative) ->
    super @name
    return @
  
###
NPC

This class contains anything that is specific to NPC's
###
class root.NPC extends root.Creature
  
  hp: 0
  
  ###
  constructor(name, modifier, hp = 0)
  params:
    name: a String to represent the NPC
    modifier: an integer that is used to roll the initiative from
    hp: an integer that contains the NPC's hit points
  returns: this Creature
  
  Creates a new instance of the NPC class and automatically rolls the initiative based on the modifier
  ###
  constructor: (@name, modifier, @hp = 0) ->
    @roll_initiative modifier
    super @name

  ###
  set_hp(hp)
  params:
    hp: an integer to set the hp to
  return: this Creature
  
  Sets the NPC's hit points to the given number
  ###
  set_hp: (hp) ->
    console.log "Setting HP of #{@name} to #{hp}"
    @hp = +hp
    return @
  
  ###
  harm(hp)
  params:
    hp: an integer to harm the NPC by
  returns: this Creature
  
  Harms the NPC by a given amount
  ###
  harm: (hp) ->
    console.log "Harming #{@name} by #{hp}"
    @hp -= +hp
    return @
  
    ###
    harm(hp)
    params:
      hp: an integer to heal the NPC by
    returns: this Creature

    Heals the NPC by a given amount
    ###
  heal: (hp) ->
    console.log "Healing #{@name} by #{hp}"
    @hp += +hp
    return @
  
  ###
  toString()
  returns: a HTML string representation of this NPC
  ###
  toString: ->
    """
    <div class="creature" data-name="#{@name}" data-initiative="#{@initiative}" data-hp="#{@hp}">
      <header>
        <hgroup>
          <h1>#{@name}</h1>
          <h2>Initiative #{@initiative}</h2>
          <h3>#{@hp} HP</h3>
        </hgroup>
      </header>
      #{@events.join " "}
      <footer>
        #{if @delayed then "<a class='undelay' href='#' data-name='#{@name}'>Undelay</a>" else ''}
        <a href="#" class="harm" data-name="#{@name}" data-amount="1">Harm 1</a>
        <a href="#" class="harm" data-name="#{@name}" data-amount="5">Harm 5</a>
        <a href="#" class="harm" data-name="#{@name}" data-amount="10">Harm 10</a>
        <a href="#" class="kill" data-name="#{@name}">Kill</a>
      </footer>
    </div>
    """
root = exports ? this
class root.Dice
  amount: null
  droplowest: null
  size: null
  modifier: null
  results: null
  dropped: null
  result: null
  
  constructor: (@roll, @droplowest) ->
    regex = /^(\d+)?d(\d+)([+\-]\d+)?$/
    matches = @roll.match regex

    # If there are any matches set them to numbers
    if matches?
      @amount = +matches[1]
      @size = +matches[2]
      @modifier = +matches[3]
      @droplowest = +@droplowest

      # otherwise set default values if they are excluded 
      @amount = 1 if isNaN @amount
      @modifier = 0 if isNaN @modifier
      @droplowest = 0 if isNaN @droplowest

      # roll those dice 
      @results = for results in [1..@amount]
        Math.floor Math.random() * @size + 1

      # remove the lowest rolls
      unless @droplowest is 0
        @dropped = @results.sort().reverse().slice -@droplowest
        @dropped.sort()
      else
        @dropped = []

      @results = @results.sort().slice @droplowest

      # Add all the dice rolls to the results
      @result = 0
      for num in @results
        @result += num

      # Calculate the final result 
      @result += @modifier
  
  get_roll: ->
    @roll
  
  get_result: ->
    @result
  
  get_results: ->
    @results
  
  get_dropped: ->
    @dropped
  
  get_droplowest: ->
    @droplowest
  
  get_modifier: ->
    @modifier
    
  toString: ->
    "Rolled #{@get_roll()}#{' dropped ' + @get_droplowest() unless @get_droplowest() is 0} and got #{@get_result()} in total"

root = exports ? this
class root.Event
  
  time: 0
  description: null
  
  constructor: (@name, @time) ->
    console.log "Creating event #{@name} with a duration #{@time}"
  
  tick: ->
    @time--
  
  set_description: (@description) ->
    console.log "Setting #{@name}'s description to #{@description}"
  
  announce: ->
    console.log "Announcing event #{@name}'s expiration"
    "#{@name} has expired. #{if @description? then @description else ''}"
  
  toString: ->
    """
    <div class="event" data-name="#{@name}" data-time="#{@time}">
      <header>
        <h1>#{@name}</h1>
        <h2>#{@time} rounds remaining</h2>
      </header>
      <p>#{if @description? then @discription else ''}</p>
    </div>
    """

class root.Timer extends root.Event
  
  tick: ->
    @time--
    if @time is 0
      @announce()

class root.Ticker extends root.Event
  
  tick: ->
    super
    return @announce()
    
  announce: ->
    console.log "Announcing event #{@name}'s tick"
    "#{@name} has ticked. #{if @description? then @description else ''}"
  
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
$ ->
  tracker = new Tracker
  
  creature_list = ->
    creatures = []
    
    creatures.concat tracker.creatures
    creatures.concat tracker.delayed
    
    return creatures
  
  redraw = ->
    $('#tracker').remove()
    $('#content').append tracker.draw()
    $('div.creature').not('div.delayed').eq(tracker.part).addClass('current_creature')
  
  $('#start').live 'click', (event)  =>
    event.preventDefault()
    $('#start').attr('id', 'next').text('Next Initiative')
    tracker.start_encounter()
    redraw()
  
  $('#next').live 'click', (event) =>
    event.preventDefault()
    tracker.next()
    redraw()
  
  $('form#add_pc').submit (event) ->
    event.preventDefault()
    
    name = $('#pc_name').val()
    initiative = +$('#pc_initiative').val()
    
    pc = new PC name, initiative
    
    tracker.add_creature pc
    $(@)[0].reset()
    
    add_creature_to_lists name
  
  $('form#add_npc').submit (event) ->
    event.preventDefault()
    
    name = $('#npc_name').val()
    modifier = +$('#npc_modifier').val()
    hp = +$('#npc_health').val()
    
    amount = +$('#npc_amount').val()
    amount = 1 if amount is NaN or amount <= 0
    if amount is 1
      npc = new NPC name, modifier, hp
      tracker.add_creature npc
      add_creature_to_lists npc.name
    else
      npcs = (new NPC "#{name} #{num}", modifier, hp for num in [1..amount])
      for npc in npcs
        console.log npc
        tracker.add_creature npc
        add_creature_to_lists npc.name
    
    $(@)[0].reset()
    
  $('form#add_event').submit (event) ->
    event.preventDefault()
    
    name = $('#event_name').val()
    duration = $('#event_duration').val()
    type = $('#event_type').val()
    description = $('#event_description').val()
    add_to = $('#add_to').val()
    
    event = if type is "Ticker" then new Ticker name, duration else new Timer name, duration
    event.set_description description
    tracker.find_creature(add_to).add_event event
    
    $(@)[0].reset()
    
  $('#delay').click (event) ->
    event.preventDefault()
    
    tracker.delay_creature tracker.find_creature $('.current_creature').data('name')
    redraw()
    
  $('.undelay').live 'click', (event) ->
    event.preventDefault()
    console.log $(@)
    tracker.undelay_creature tracker.find_creature $(@).data 'name'
    redraw()
    
  add_creature_to_lists = (name) ->
    $('select#add_to').append "<option value='#{name}'>#{name}</option>"
  
  $('.harm').live 'click', (event) ->
    event.preventDefault()
    
    amount = $(@).data('amount')
    creature = tracker.find_creature $(@).data('name')
    
    creature.harm amount
    redraw()
  
  $('.kill').live 'click', (event) ->
    event.preventDefault()
    
    creature = tracker.find_creature $(@).data('name')
    tracker.kill_creature creature
    
    redraw()
    

