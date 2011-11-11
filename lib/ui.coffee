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
    
