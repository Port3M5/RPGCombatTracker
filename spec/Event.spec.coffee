Event = require('../lib/Event.class').Event
Timer = require('../lib/Event.class').Timer
Ticker = require('../lib/Event.class').Ticker

describe 'Event', ->
  
  event = null
  
  beforeEach ->
    event = new Event "BaseEvent", 2
    
  
  it 'should return itself from the constructor', ->
    expect(event).toBe instanceof Event
    expect(event.name).toBe 'BaseEvent'
    expect(event.time).toBe 2
  
  it 'should be able to have a description set', ->
    event.set_description 'testing'
    expect(event.description).toBe 'testing'
  
  it 'should be able to tick and reduce the time by one', ->
    event.tick()
    expect(event.time).toBe 1
  
  it 'should be able to announce its expiration', ->
    announce = event.announce()
    expect(typeof announce).toBe 'string'
  
describe 'Ticker', ->
  
  ticker = null
  
  beforeEach ->
    ticker = new Ticker "Ticker", 2
    
  it 'should return a message on each tick and reduce the time', ->
    tick = ticker.tick()
    expect(typeof tick).toBe 'string'
    expect(ticker.time).toBe 1
  
  it 'should return a string on an announce', ->
    announce = ticker.announce()
    expect(typeof announce).toBe 'string'

describe 'Timer', ->
  timer = null
  
  beforeEach ->
    timer = new Timer "Timer", 2
  
  it "should reduce the time on tick and then announce its expirey when time is 0", ->
    tick = timer.tick()
    expect(typeof tick).toBe 'number'
    expect(timer.time).toBe 1
    tick = timer.tick()
    expect(typeof tick).toBe 'string'
    expect(timer.time).toBe 0