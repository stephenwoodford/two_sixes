DICE_ICONS = [0, '⚀','⚁','⚂','⚃','⚄','⚅'];

Player = function (obj) {
    this.seatNumber = obj["seatNumber"];
    this.handle = obj["handle"];
    this.isCurrentPlayer = ko.observable(false);
    this.diceArray = ko.observableArray();
    this.lostDie = ko.observable(false);

    this.assignDice = function(diceArray) {
        this.diceArray(diceArray);
    }

    this.diceIcons = ko.computed(function() {
        if (this.isCurrentPlayer()) {
            return this.diceArray().map(function(elt) { return DICE_ICONS[elt] }).join(" ");
        } else {
            return "No dice";
        }
    }, this);
}
