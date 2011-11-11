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
