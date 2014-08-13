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
    self.inviteIndex = function(email) {
        for (var i = 0; i < self.invites().length; i++)
            if (self.invites()[i].email == email)
                return i;
        return -1;
    }
    self.inviteFor = function(email) {
        var indx = self.inviteIndex(email);
        if (indx < 0)
            return;
        return self.invites()[indx];
    }
    self.removeInvite = function(email) {
        var indx = self.inviteIndex(email);
        if (indx < 0)
            return;
        self.invites.splice(indx, 1);
    }

    self.process = function(event) {
        if (event.event == "Player Added") {
            self.addPlayer(new Player(event.data));
        } else if (event.event == "Invite Sent") {
            self.addInvite(new Invite(event.data));
        } else if (event.event == "Invite Accepted") {
            var invite = self.inviteFor(event.data.email);
            if (invite) {
                invite.accept();
            } else {
                self.addInvite(new Invite(event.data));
            }
        } else if (event.event == "Invite Declined") {
            var invite = self.inviteFor(event.data.email);
            if (invite) {
                invite.decline();
            } else {
                self.addInvite(new Invite(event.data));
            }
        } else if (event.event == "Invite Revoked") {
            self.removeInvite(event.data.email);
        } else if (event.event == "New Round") {
            window.location.reload();
        }
    }

    self.wait = function() {
        jqxhr = $.get(self.eventsUrl, { prev_event: self.highwaterMark}, function(data){
            for (var i = 0; i < data.length; i++) {
                if (data[i].number > self.highwaterMark)
                    self.highwaterMark = data[i].number;
                self.process(data[i])
            }
        });
        jqxhr.always(function(){
            setTimeout(self.wait, 1000);
        });
    }
}
