function GameViewModel() {
    var self = this;

    self.players = ko.observableArray();

    self.addPlayer = function(player) {
        self.players.push(player);
    }
}
