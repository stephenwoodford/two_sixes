function GameViewModel(eventsUrl) {
    var self = this;
    this.eventsUrl = eventsUrl;
    this.highwaterMark = -1;

    self.players = ko.observableArray();

    self.addPlayer = function(player) {
        self.players.push(player);
    }

    self.invites = ko.observableArray();
    self.addInvite = function(invite) {
        self.invites.push(invite);
    }
    self.openInvites = ko.computed(function(){
        return this.invites().filter(function(invite){
            return invite.isOpen();
        });
    }, this);
    self.declinedInvites = ko.computed(function(){
        return this.invites().filter(function(invite){
            return invite.isDeclined();
        });
    }, this);

    self.process = function(event) {
        if (event.event == "Player Added") {
            self.addPlayer(new Player(event.data));
        }
    }

    self.wait = function() {
        $.get(self.eventsUrl, { prev_event: self.highwaterMark}, function(data){
            for (var i = 0; i < data.length; i++) {
                if (data[i].number > self.highwaterMark)
                    self.highwaterMark = data[i].number;
                self.process(data[i])
            }
        });
        setTimeout(self.wait, 1000);
    }
}
