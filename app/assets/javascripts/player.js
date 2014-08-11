DICE_ICONS = [0, '⚀','⚁','⚂','⚃','⚄','⚅'];

Player = function (seatNumber, handle, currentPlayer) {
    this.seatNumber = seatNumber;
    this.handle = handle;
    this.currentPlayer = currentPlayer;
    this.diceArray = ko.observableArray();

    this.assignDice = function(diceArray) {
        this.diceArray(diceArray);
    }

    this.diceIcons = ko.computed(function() {
        if (this.currentPlayer) {
            return this.diceArray().map(function(elt) { return DICE_ICONS[elt] }).join(" ");
        } else {
            return "No dice";
        }
    }, this);
}
