root = exports ? this
Dice = require('./Dice.class').Dice
Event = require('./Event.class').Event
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