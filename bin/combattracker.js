(function() {
  "use strict";  var root;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  /*
  Creature
  
  The Base class for PC's and NPC's. Stores data such as the name, initiative and if it's delayed. Also contains an array of events that are currently in effect for the creature
  */
  root.Creature = (function() {
    Creature.prototype.name = null;
    Creature.prototype.initiative = null;
    Creature.prototype.delayed = false;
    Creature.prototype.events = [];
    /*
      constructor(name)
      params:
        name: a String that represents the creature
      returns: This Creature
      
      Creates a new creature and assigns the name to the attribute name
      */
    function Creature(name) {
      this.name = name;
      console.log("Creating Creature called " + this.name);
      return this;
    }
    /*
      add_event(event)
      params:
        event: an Event Object
      returns: This Creature
      
      Adds the given event to the events attribute
      */
    Creature.prototype.add_event = function(event) {
      console.log("Adding event " + event.name + " to " + this.name);
      this.events.push(event);
      return this;
    };
    /*
      is_delayed()
      returns: boolean
      
      If the creature is delayed returns true
      */
    Creature.prototype.is_delayed = function() {
      return this.delayed;
    };
    /*
      set_initiative(initiative)
      params:
        initiative: an integer
      returns: This Creature
      
      sets the initiative to the given number.
      Useful if the creature has been delayed and needs to have its initiative changed to reflect this.
      */
    Creature.prototype.set_initiative = function(initiative) {
      this.initiative = initiative;
      console.log("Setting " + this.name + "'s initiative to " + this.initiative);
      return this;
    };
    /*
      roll_initiative(modifier)
      params:
        modifier: an integer
      returns: This Creature
      
      Rolls the initiative based on the modifier and stores it.
      */
    Creature.prototype.roll_initiative = function(modifier) {
      var roll;
      console.log("Rolling the initiative of " + this.name + " with a modifier of " + modifier);
      roll = new Dice("d20+" + modifier, 0);
      this.initiative = roll.result;
      return this;
    };
    /*
      tick()
      returns: This Creature
      
      Triggers any events that is attached to the creature and removes any that should not exist anymore.
      */
    Creature.prototype.tick = function() {
      var event, _i, _len, _ref;
      _ref = this.events;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        if (event instanceof Event) {
          event.tick();
          if (event.time === 0) {
            this.events.splice(_i, 1);
          }
        }
      }
      return this;
    };
    /*
      toString()
      returns: a HTML string representation of this creature
      */
    Creature.prototype.toString = function() {
      var event;
      return "<div class=\"creature\" data-name=\"" + this.name + "\" data-initiative=\"" + this.initiative + "\">\n  <header>\n    <hgroup>\n      <h1>" + this.name + "</h1>\n      <h2>Initiative " + this.initiative + "</h2>\n    </hgroup>\n  </header>\n  " + ((function() {
        var _i, _len, _ref, _results;
        _ref = this.events;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          event = _ref[_i];
          _results.push(event);
        }
        return _results;
      }).call(this)) + "\n  <footer>\n    " + (this.delayed ? "<a class='undelay' href='#' data-name='" + this.name + "'>Undelay</a>" : '') + "\n    <a href=\"#\" class=\"kill\">Kill</a>\n  </footer>\n</div>";
    };
    return Creature;
  })();
  /*
  PC
  
  This class contains anything that is specific to PC's
  */
  root.PC = (function() {
    __extends(PC, root.Creature);
    /*
      constructor(name, initiative)
      params:
        name: a String to represent the PC
        initiative: the Initiative the Player Rolled
      returns: this PC
      
      Creates a new Instance of the PC class and gives it a name and initiative
      */
    function PC(name, initiative) {
      this.name = name;
      this.initiative = initiative;
      PC.__super__.constructor.call(this, this.name);
      return this;
    }
    return PC;
  })();
  /*
  NPC
  
  This class contains anything that is specific to NPC's
  */
  root.NPC = (function() {
    __extends(NPC, root.Creature);
    NPC.prototype.hp = 0;
    /*
      constructor(name, modifier, hp = 0)
      params:
        name: a String to represent the NPC
        modifier: an integer that is used to roll the initiative from
        hp: an integer that contains the NPC's hit points
      returns: this Creature
      
      Creates a new instance of the NPC class and automatically rolls the initiative based on the modifier
      */
    function NPC(name, modifier, hp) {
      this.name = name;
      this.hp = hp != null ? hp : 0;
      this.roll_initiative(modifier);
      NPC.__super__.constructor.call(this, this.name);
    }
    /*
      set_hp(hp)
      params:
        hp: an integer to set the hp to
      return: this Creature
      
      Sets the NPC's hit points to the given number
      */
    NPC.prototype.set_hp = function(hp) {
      console.log("Setting HP of " + this.name + " to " + hp);
      this.hp = +hp;
      return this;
    };
    /*
      harm(hp)
      params:
        hp: an integer to harm the NPC by
      returns: this Creature
      
      Harms the NPC by a given amount
      */
    NPC.prototype.harm = function(hp) {
      console.log("Harming " + this.name + " by " + hp);
      this.hp -= +hp;
      return this;
      /*
          harm(hp)
          params:
            hp: an integer to heal the NPC by
          returns: this Creature
      
          Heals the NPC by a given amount
          */
    };
    NPC.prototype.heal = function(hp) {
      console.log("Healing " + this.name + " by " + hp);
      this.hp += +hp;
      return this;
    };
    /*
      toString()
      returns: a HTML string representation of this NPC
      */
    NPC.prototype.toString = function() {
      return "<div class=\"creature\" data-name=\"" + this.name + "\" data-initiative=\"" + this.initiative + "\" data-hp=\"" + this.hp + "\">\n  <header>\n    <hgroup>\n      <h1>" + this.name + "</h1>\n      <h2>Initiative " + this.initiative + "</h2>\n      <h3>" + this.hp + " HP</h3>\n    </hgroup>\n  </header>\n  " + (this.events.join(" ")) + "\n  <footer>\n    " + (this.delayed ? "<a class='undelay' href='#' data-name='" + this.name + "'>Undelay</a>" : '') + "\n    <a href=\"#\" class=\"harm\" data-name=\"" + this.name + "\" data-amount=\"1\">Harm 1</a>\n    <a href=\"#\" class=\"harm\" data-name=\"" + this.name + "\" data-amount=\"5\">Harm 5</a>\n    <a href=\"#\" class=\"harm\" data-name=\"" + this.name + "\" data-amount=\"10\">Harm 10</a>\n    <a href=\"#\" class=\"kill\" data-name=\"" + this.name + "\">Kill</a>\n  </footer>\n</div>";
    };
    return NPC;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.Dice = (function() {
    Dice.prototype.amount = null;
    Dice.prototype.droplowest = null;
    Dice.prototype.size = null;
    Dice.prototype.modifier = null;
    Dice.prototype.results = null;
    Dice.prototype.dropped = null;
    Dice.prototype.result = null;
    function Dice(roll, droplowest) {
      var matches, num, regex, results, _i, _len, _ref;
      this.roll = roll;
      this.droplowest = droplowest;
      regex = /^(\d+)?d(\d+)([+\-]\d+)?$/;
      matches = this.roll.match(regex);
      if (matches != null) {
        this.amount = +matches[1];
        this.size = +matches[2];
        this.modifier = +matches[3];
        this.droplowest = +this.droplowest;
        if (isNaN(this.amount)) {
          this.amount = 1;
        }
        if (isNaN(this.modifier)) {
          this.modifier = 0;
        }
        if (isNaN(this.droplowest)) {
          this.droplowest = 0;
        }
        this.results = (function() {
          var _ref, _results;
          _results = [];
          for (results = 1, _ref = this.amount; 1 <= _ref ? results <= _ref : results >= _ref; 1 <= _ref ? results++ : results--) {
            _results.push(Math.floor(Math.random() * this.size + 1));
          }
          return _results;
        }).call(this);
        if (this.droplowest !== 0) {
          this.dropped = this.results.sort().reverse().slice(-this.droplowest);
          this.dropped.sort();
        } else {
          this.dropped = [];
        }
        this.results = this.results.sort().slice(this.droplowest);
        this.result = 0;
        _ref = this.results;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          num = _ref[_i];
          this.result += num;
        }
        this.result += this.modifier;
      }
    }
    Dice.prototype.get_roll = function() {
      return this.roll;
    };
    Dice.prototype.get_result = function() {
      return this.result;
    };
    Dice.prototype.get_results = function() {
      return this.results;
    };
    Dice.prototype.get_dropped = function() {
      return this.dropped;
    };
    Dice.prototype.get_droplowest = function() {
      return this.droplowest;
    };
    Dice.prototype.get_modifier = function() {
      return this.modifier;
    };
    Dice.prototype.toString = function() {
      return "Rolled " + (this.get_roll()) + (this.get_droplowest() !== 0 ? ' dropped ' + this.get_droplowest() : void 0) + " and got " + (this.get_result()) + " in total";
    };
    return Dice;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.Event = (function() {
    Event.prototype.time = 0;
    Event.prototype.description = null;
    function Event(name, time) {
      this.name = name;
      this.time = time;
      console.log("Creating event " + this.name + " with a duration " + this.time);
    }
    Event.prototype.tick = function() {
      return this.time--;
    };
    Event.prototype.set_description = function(description) {
      this.description = description;
      return console.log("Setting " + this.name + "'s description to " + this.description);
    };
    Event.prototype.announce = function() {
      console.log("Announcing event " + this.name + "'s expiration");
      return "" + this.name + " has expired. " + (this.description != null ? this.description : '');
    };
    Event.prototype.toString = function() {
      return "<div class=\"event\" data-name=\"" + this.name + "\" data-time=\"" + this.time + "\">\n  <header>\n    <h1>" + this.name + "</h1>\n    <h2>" + this.time + " rounds remaining</h2>\n  </header>\n  <p>" + (this.description != null ? this.discription : '') + "</p>\n</div>";
    };
    return Event;
  })();
  root.Timer = (function() {
    __extends(Timer, root.Event);
    function Timer() {
      Timer.__super__.constructor.apply(this, arguments);
    }
    Timer.prototype.tick = function() {
      this.time--;
      if (this.time === 0) {
        return this.announce();
      }
    };
    return Timer;
  })();
  root.Ticker = (function() {
    __extends(Ticker, root.Event);
    function Ticker() {
      Ticker.__super__.constructor.apply(this, arguments);
    }
    Ticker.prototype.tick = function() {
      Ticker.__super__.tick.apply(this, arguments);
      return this.announce();
    };
    Ticker.prototype.announce = function() {
      console.log("Announcing event " + this.name + "'s tick");
      return "" + this.name + " has ticked. " + (this.description != null ? this.description : '');
    };
    return Ticker;
  })();
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.Tracker = (function() {
    Tracker.prototype.creatures = [];
    Tracker.prototype.started = false;
    Tracker.prototype.round = 0;
    Tracker.prototype.part = 0;
    function Tracker() {
      console.log("Creating tracker object");
    }
    Tracker.prototype.add_creature = function(creature) {
      console.log("Adding " + creature.name + " to tracker");
      return this.creatures.push(creature);
    };
    Tracker.prototype.draw = function() {
      console.log("Drawing the tracker");
      return this.toString();
    };
    Tracker.prototype.get_current_creature = function() {
      var current;
      console.log("Getting current creature");
      current = this.get_creatures()[this.part];
      return current;
    };
    Tracker.prototype.kill_creature = function(creature) {
      var num, _i, _len, _ref, _results;
      console.log("Killing " + creature.name);
      _ref = this.creatures;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        num = _ref[_i];
        _results.push(num === creature ? (this.creatures.splice(_i, 1), this.tick()) : void 0);
      }
      return _results;
    };
    Tracker.prototype.delay_creature = function(creature) {
      console.log("Delaying " + creature.name);
      creature.delayed = true;
      return this.tick();
    };
    Tracker.prototype.get_delayed_creatures = function() {
      var creature, delayed, _i, _len, _ref;
      delayed = [];
      _ref = this.creatures;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        creature = _ref[_i];
        if (creature.is_delayed()) {
          delayed.push(creature);
        }
      }
      return delayed;
    };
    Tracker.prototype.get_creatures = function() {
      var creature, undelayed, _i, _len, _ref;
      undelayed = [];
      _ref = this.creatures;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        creature = _ref[_i];
        if (!creature.is_delayed()) {
          undelayed.push(creature);
        }
      }
      return undelayed;
    };
    Tracker.prototype.undelay_creature = function(creature) {
      var num, _i, _len, _ref, _results;
      console.log("Undelaying " + creature.name + " and changing initiative");
      _ref = this.creatures;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        num = _ref[_i];
        _results.push(num === creature && creature.is_delayed() ? (creature.initiative = this.get_creatures()[this.part].initiative - 1, creature.delayed = false, this.sort_by_initiative()) : void 0);
      }
      return _results;
    };
    Tracker.prototype.compare_initiatives = function(a, b) {
      return b.initiative - a.initiative;
    };
    Tracker.prototype.sort_by_initiative = function() {
      console.log("Sorting creatures by initiative");
      return this.creatures.sort(this.compare_initiatives);
    };
    Tracker.prototype.find_creature = function(name) {
      var creature, _i, _len, _ref;
      console.log("Finding " + name);
      _ref = this.creatures;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        creature = _ref[_i];
        if (creature.name === name && creature instanceof Creature) {
          return creature;
        }
      }
    };
    Tracker.prototype.start_encounter = function() {
      if (!this.started) {
        console.log("Starting the encounter");
        this.sort_by_initiative();
        this.round = 1;
        this.started = true;
        return this.tick();
      }
    };
    Tracker.prototype.next = function() {
      console.log("Going to the next creature");
      this.part = (this.part + 1) % this.get_creatures().length;
      if (this.part === 0) {
        this.round++;
      }
      return this.tick();
    };
    Tracker.prototype.tick = function() {
      var creature;
      console.log("Round " + this.round + " part " + this.part + ". " + (this.get_current_creature().name) + " to go.");
      creature = this.get_current_creature();
      creature.tick();
      return creature;
    };
    Tracker.prototype.toString = function() {
      var creature;
      return "<div id=\"tracker\" data-round=\"" + this.round + "\">\n  <header>\n    <hgroup>\n      <h1>Round " + this.round + "</h1>\n    </hgroup>\n  </header>\n  <div class=\"creatures\">\n    " + ((function() {
        var _i, _len, _ref, _results;
        _ref = this.get_creatures();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          creature = _ref[_i];
          _results.push(creature);
        }
        return _results;
      }).call(this)) + "\n  </div>\n  <div class=\"creatures delayed\">\n    " + ((function() {
        var _i, _len, _ref, _results;
        _ref = this.get_delayed_creatures();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          creature = _ref[_i];
          _results.push(creature);
        }
        return _results;
      }).call(this)) + "\n  </div>\n  <div class=\"clear\"></div>\n</div>";
    };
    return Tracker;
  })();
  $(function() {
    var add_creature_to_lists, creature_list, redraw, tracker;
    tracker = new Tracker;
    creature_list = function() {
      var creatures;
      creatures = [];
      creatures.concat(tracker.creatures);
      creatures.concat(tracker.delayed);
      return creatures;
    };
    redraw = function() {
      $('#tracker').remove();
      $('#content').append(tracker.draw());
      return $('div.creature').not('div.delayed').eq(tracker.part).addClass('current_creature');
    };
    $('#start').live('click', __bind(function(event) {
      event.preventDefault();
      $('#start').attr('id', 'next').text('Next Initiative');
      tracker.start_encounter();
      return redraw();
    }, this));
    $('#next').live('click', __bind(function(event) {
      event.preventDefault();
      tracker.next();
      return redraw();
    }, this));
    $('form#add_pc').submit(function(event) {
      var initiative, name, pc;
      event.preventDefault();
      name = $('#pc_name').val();
      initiative = +$('#pc_initiative').val();
      pc = new PC(name, initiative);
      tracker.add_creature(pc);
      $(this)[0].reset();
      return add_creature_to_lists(name);
    });
    $('form#add_npc').submit(function(event) {
      var amount, hp, modifier, name, npc, npcs, num, _i, _len;
      event.preventDefault();
      name = $('#npc_name').val();
      modifier = +$('#npc_modifier').val();
      hp = +$('#npc_health').val();
      amount = +$('#npc_amount').val();
      if (amount === NaN || amount <= 0) {
        amount = 1;
      }
      if (amount === 1) {
        npc = new NPC(name, modifier, hp);
        tracker.add_creature(npc);
        add_creature_to_lists(npc.name);
      } else {
        npcs = (function() {
          var _results;
          _results = [];
          for (num = 1; 1 <= amount ? num <= amount : num >= amount; 1 <= amount ? num++ : num--) {
            _results.push(new NPC("" + name + " " + num, modifier, hp));
          }
          return _results;
        })();
        for (_i = 0, _len = npcs.length; _i < _len; _i++) {
          npc = npcs[_i];
          console.log(npc);
          tracker.add_creature(npc);
          add_creature_to_lists(npc.name);
        }
      }
      return $(this)[0].reset();
    });
    $('form#add_event').submit(function(event) {
      var add_to, description, duration, name, type;
      event.preventDefault();
      name = $('#event_name').val();
      duration = $('#event_duration').val();
      type = $('#event_type').val();
      description = $('#event_description').val();
      add_to = $('#add_to').val();
      event = type === "Ticker" ? new Ticker(name, duration) : new Timer(name, duration);
      event.set_description(description);
      tracker.find_creature(add_to).add_event(event);
      return $(this)[0].reset();
    });
    $('#delay').click(function(event) {
      event.preventDefault();
      tracker.delay_creature(tracker.find_creature($('.current_creature').data('name')));
      return redraw();
    });
    $('.undelay').live('click', function(event) {
      event.preventDefault();
      console.log($(this));
      tracker.undelay_creature(tracker.find_creature($(this).data('name')));
      return redraw();
    });
    add_creature_to_lists = function(name) {
      return $('select#add_to').append("<option value='" + name + "'>" + name + "</option>");
    };
    $('.harm').live('click', function(event) {
      var amount, creature;
      event.preventDefault();
      amount = $(this).data('amount');
      creature = tracker.find_creature($(this).data('name'));
      creature.harm(amount);
      return redraw();
    });
    return $('.kill').live('click', function(event) {
      var creature;
      event.preventDefault();
      creature = tracker.find_creature($(this).data('name'));
      tracker.kill_creature(creature);
      return redraw();
    });
  });
}).call(this);
