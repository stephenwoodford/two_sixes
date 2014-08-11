Player = function (seatNumber, handle, currentPlayer) {
    this.seatNumber = seatNumber;
    this.handle = handle;
    this.currentPlayer = currentPlayer;
    this.diceArray = ko.observableArray();

    this.assignDice = function(diceArray) {
        this.diceArray(diceArray);
    }

    this.dice = ko.computed(function() {
        if (this.currentPlayer) {
            return this.diceArray().join(" ");
        } else {
            return "No dice";
        }
    }, this);
}
