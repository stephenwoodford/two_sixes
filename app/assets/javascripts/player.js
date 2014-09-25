Player = function (obj) {
    this.seatNumber = obj["seatNumber"];
    this.handle = obj["handle"];
    this.isCurrentPlayer = ko.observable(false);
    this.diceArray = ko.observableArray();
    this.diceCount = ko.observable(obj["diceCount"]);
    this.lostDie = ko.observable(false);
    this.hasDice = ko.observable(obj["hasDice"] || false);
    this.diceTotal = ko.observable(-1);
    this.calledBS = ko.observable(false);

    this.assignDice = function(diceArray) {
        this.diceArray(diceArray);
    };

    this.reset = function(hasDice) {
        this.lostDie(false);
        this.hasDice(hasDice);
        this.diceTotal(-1);
        this.calledBS(false);
    };

    this.diceIcons = ko.computed(function() {
        if (this.isCurrentPlayer()) {
            return this.diceArray().map(function(elt) { return DICE_ICONS[elt]; }).join(" ");
        } else {
            return "No dice";
        }
    }, this);

    this.hiddenDiceIcons = ko.computed(function() {
        return Array(this.diceCount()+1).join("◘");
    }, this);

    this.noDice = ko.computed(function() {
        return !this.hasDice();
    }, this);

    this.loseDie = function() {
        this.lostDie(true);
        this.diceCount(this.diceCount() - 1);
    };
};
