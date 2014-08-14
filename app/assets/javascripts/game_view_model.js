function GameViewModel(urls) {
    var self = this;
    this.eventsUrl = urls["events"];
    this.bidUrl = urls["bid"];
    this.bsUrl = urls["bs"];
    this.highwaterMark = -1;
    this.bidder = ko.observable(0);
    this.waiting = false;
    this.paused = false;
    this.currentBid = ko.observable();
    this.eventHandlers = {};

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

    self.dispatch = function(event) {
        var func = self.eventHandlers[event.event];
        if (func) { func(event); }
        return event.number;
    }
    self.eventHandlers["Player Added"] = function(event) {
        self.addPlayer(new Player(event.data));
    }
    self.eventHandlers["Invite Sent"] = function(event) {
            self.addInvite(new Invite(event.data));
    }
    self.eventHandlers["Invite Accepted"] = function(event) {
        var invite = self.inviteFor(event.data.email);
        if (invite) {
            invite.accept();
        } else {
            self.addInvite(new Invite(event.data));
        }
    }
    self.eventHandlers["Invite Declined"] = function(event) {
        var invite = self.inviteFor(event.data.email);
        if (invite) {
            invite.decline();
        } else {
            self.addInvite(new Invite(event.data));
        }
    }
    self.eventHandlers["Invite Revoked"] = function(event) {
        self.removeInvite(event.data.email);
    }
    self.eventHandlers["New Round"] = function(event) {
        if (waiting) {
            window.location.reload();
        }
    }
    self.eventHandlers["BS"] = function(event) {
        alert("BS Called");
    }
    self.eventHandlers["Bid"] = function(event) {
        var bid = new Bid(event.data.number, event.data.faceValue);
        self.currentBid(bid);
        self.bidder((self.bidder() + 1) % self.players().length);
    }

    self.bid = function(bid) {
        $.post(self.bidUrl, { number: bid.number, face_value: bid.faceValue }, function(data) {
            alert("successful bid.")
        });
    }

    self.bs = function() {
        $.post(self.bsUrl, {}, function(data) {
            alert("successful bs.")
        });
    }

    self.loop = function() {
        jqxhr = $.get(self.eventsUrl, { prev_event: self.highwaterMark}, function(data){
            for (var i = 0; i < data.length; i++) {
                var seq_num = self.dispatch(data[i]);
                /* Only update highwaterMark if the event's sequence number is actually higher.
                   (Hopefully we never actually process events out of order.)
                 */
                if (seq_num > self.highwaterMark)
                    self.highwaterMark = seq_num;
            }
        });
        jqxhr.always(function(){
            if (!self.paused)
                setTimeout(self.loop, 2000);
        });
    }

    self.pause = function() { self.paused = true; }
}
