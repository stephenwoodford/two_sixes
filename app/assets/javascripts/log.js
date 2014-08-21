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
}

RoundLog = function() {
    this.events = ko.observableArray();
    this.live = ko.observable(true);
    this.show = ko.observable(false);
    this.description = ko.observable("");
    this.playerLostDie = ko.observable(false);

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
}
