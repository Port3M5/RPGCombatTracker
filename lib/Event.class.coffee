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
    super
    if @time is 0
      return @announce()
    else
      return @time

class root.Ticker extends root.Event
  
  tick: ->
    super
    return @announce()
    
  announce: ->
    console.log "Announcing event #{@name}'s tick"
    "#{@name} has ticked. #{if @description? then @description else ''}"
  