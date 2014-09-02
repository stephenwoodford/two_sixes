Log = function() {
    this.rounds = ko.observableArray();

    this.currentRound = function() {
        return this.rounds()[0];
    }

    this.addBid = function(player, bid) {
        this.currentRound().addBid(player, bid);
    }

    this.addDieLost = function(description, playerLost) {
        this.currentRound().addDieLost(description, playerLost);
    }

    this.addRound = function() {
        this.rounds.unshift(new RoundLog());
    }

    this.addRoll = function(player, dice) {
        this.currentRound().addRoll(player, dice);
    }
}

RoundLog = function() {
    this.events = ko.observableArray();
    this.live = ko.observable(true);
    this.show = ko.observable(false);
    this.description = ko.observable("");
    this.playerLostDie = ko.observable(false);
    this.diceRolls = ko.observableArray();

    this.addBid = function(player, bid) {
        this.events.push(player.handle + ' bid ' + bid.toString());
    }
    this.addDieLost = function(description, playerLost) {
        this.live(false);
        this.description(description);
        this.playerLostDie(playerLost || false);
    }
    this.showBody = ko.computed(function(){
        return this.live() || this.show();
    }, this);

    this.addRoll = function(player, dice) {
        this.diceRolls().push(new DiceRollLog(player, dice));
    }
}

DiceRollLog = function(player, dice) {
    this.player = ko.observable(player);
    this.dice = ko.observableArray(dice);

    this.ones = ko.computed(function(){
        return this.dice().filter(function(die) { return die == 1; }).length;
    }, this);

    this.twos = ko.computed(function(){
        return this.dice().filter(function(die) { return die == 2; }).length;
    }, this);

    this.threes = ko.computed(function(){
        return this.dice().filter(function(die) { return die == 3; }).length;
    }, this);

    this.fours = ko.computed(function(){
        return this.dice().filter(function(die) { return die == 4; }).length;
    }, this);

    this.fives = ko.computed(function(){
        return this.dice().filter(function(die) { return die == 5; }).length;
    }, this);

    this.sixes = ko.computed(function(){
        return this.dice().filter(function(die) { return die == 6; }).length;
    }, this);
}
