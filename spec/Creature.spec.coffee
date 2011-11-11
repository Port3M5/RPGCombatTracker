Creature = require('../lib/Creature.class').Creature
PC = require('../lib/Creature.class').PC
NPC = require('../lib/Creature.class').NPC

Event = require('../lib/Event.class').Event
Dice = require('../lib/Dice.class').Dice
  
# Disable logging

describe 'Creature', ->
  
  creature = null
  
  beforeEach ->
    creature = new Creature "Test"
  
  it "Should create a Creature called Test and return itself", ->
    expect(creature).toBe instanceof Creature
    expect(creature.name).toBe 'Test'
  
  it "Should be able to add an event to itself then return itself", ->
    event = new Event "Test", 2
    
    expect(creature.add_event(event) instanceof Creature).toBe true
    expect(creature.events[0]).toBe event
    
  it "should be able to be delayed and check if it is", ->
    expect(creature.is_delayed()).toBe no
    creature.delayed = true
    expect(creature.is_delayed()).toBe yes
  
  it "should be able to set the initiative to a specific number", ->
    expect(creature.initiative).toBe null
    creature.set_initiative(10)
    expect(creature.initiative).toBe 10
    
  it "should be able to roll an initiative based on a given number", ->
    expect(creature.initiative).toBe null
    
    # Repeat this test 100 times to try to make sure
    for num in [1..100]
      creature.roll_initiative(2)
      expect(3 <= creature.initiative <= 22).toBe true
  
  it "shoud be able to trigger any events that it has attatched to it", ->
    eventamount = 2
    for num in [1..eventamount]
      event = new Event "Test #{num}", 2
      creature.add_event(event)
    
    expect(creature.tick()).toBe instanceof Creature
    for event in creature.events
      expect(event).toBe instanceof Event
      expect(event.time).toBe 1
  
describe 'PC', ->
  
  pc = null
  
  it 'should take a name an initiative in its constructor and return itself', ->
    pc = new PC "Test", 16
    expect(pc).toBe instanceof PC
    expect(pc.name).toBe "Test"
    expect(pc.initiative).toBe 16

describe 'NPC', ->
  
  npc = null
  
  beforeEach ->
    npc = new NPC "Test", 2
  
  it "Should take a name, dice modifier and health and return itself", ->
    expect(npc).toBe instanceof NPC
    expect(npc.name).toBe "Test"
    expect(npc.hp).toBe 0
    expect(3 <= npc.initiative <= 22).toBe true
  
  it "Should allow the HP to be set to a specify number then return itself", ->
    expect(npc.set_hp 6).toBe instanceof NPC
    expect(npc.hp).toBe 6
  
  it "Should allow the hp to be reduced by a specific amount, then return itself", ->
    expect(npc.harm 2).toBe instanceof NPC
    expect(npc.hp).toBe -2
  
  it "Should allow the hp to be increased by a specific amount, then return itself", ->
    expect(npc.heal 2).toBe instanceof NPC
    expect(npc.hp).toBe 2
