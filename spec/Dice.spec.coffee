Dice = require('../lib/Dice.class').Dice

describe 'Dice', ->
  
  dice = null
  
  beforeEach ->
    dice = new Dice "4d6+2", 1
  
  it 'Should take a string and amount of dice to drop and return itself', ->
    expect(dice).toBe instanceof Dice
  
  it 'Should roll a realistic result', ->
    dice = null
    for num in [1..100]
      dice = new Dice("4d6+2", 1)
      expect(5 <= dice.get_result() <= 20).toBe true
  
  
    