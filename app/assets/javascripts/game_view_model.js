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
    this.events = [];
    this.processing = false;

    self.players = ko.observableArray();
    self.addPlayer = function(player) {
        self.players.push(player);
    }
    self.playerInSeat = function(seatNumber) {
        for (var i = 0; i < self.players().length; i++) {
            player = self.players()[i];
            if (player.seatNumber == seatNumber)
                return player;
        }
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

    /*
       Call an event handler for a given event, based upon that event's name.
       Return the number of milliseconds to wait before processing the next
       event (if any.)
    */
    self.dispatch = function(event) {
        var func = self.eventHandlers[event.event];
        if (func)
            return func(event);
        else
            return 0;
    }
    self.eventHandlers["Player Added"] = function(event) {
        self.addPlayer(new Player(event.data));
        return 0;
    }
    self.eventHandlers["Invite Sent"] = function(event) {
        self.addInvite(new Invite(event.data));
        return 0;
    }
    self.eventHandlers["Invite Accepted"] = function(event) {
        var invite = self.inviteFor(event.data.email);
        if (invite) {
            invite.accept();
        } else {
            self.addInvite(new Invite(event.data));
        }
        return 0;
    }
    self.eventHandlers["Invite Declined"] = function(event) {
        var invite = self.inviteFor(event.data.email);
        if (invite) {
            invite.decline();
        } else {
            self.addInvite(new Invite(event.data));
        }
        return 0;
    }
    self.eventHandlers["Invite Revoked"] = function(event) {
        self.removeInvite(event.data.email);
        return 0;
    }
    self.eventHandlers["New Round"] = function(event) {
        if (waiting) {
            window.location.reload();
        }
        return 0;
    }
    self.eventHandlers["BS"] = function(event) {
        alert("BS Called");
        return 0;
    }
    self.eventHandlers["Bid"] = function(event) {
        var bid = new Bid(event.data.number, event.data.faceValue);
        self.currentBid(bid);
        self.bidder(self.nextBidder());
        return 1000;
    }
    self.eventHandlers["Die Lost"] = function(event) {
        var player = self.playerInSeat(event.data.seat);
        player.lostDie(true);
        return 10000;
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

    self.process = function() {
        self.processing = true;
        if (self.events.length == 0) {
            self.processing = false;
            return;
        }
        var event = self.events.shift();
        var delay = self.dispatch(event);
        /* Only update highwaterMark if the event's sequence number is actually higher.
           (Hopefully we never actually process events out of order.)
        */
        if (event.number > self.highwaterMark)
            self.highwaterMark = event.number;
        if (delay == 0)
            self.process();
        else
            setTimeout(self.process, delay);
    }

    self.loop = function() {
        jqxhr = $.get(self.eventsUrl, { prev_event: self.highwaterMark}, function(data){
            self.events = self.events.concat(data);
            if (!self.processing)
                self.process();
        });
        jqxhr.always(function(){
            if (!self.paused)
                setTimeout(self.loop, 2000);
        });
    }

    self.pause = function() { self.paused = true; }

    self.nextBidder = function() {
        var next = (self.bidder() + 1) % self.players().length;
        while (self.playerInSeat(next).noDice())
            next = (next + 1) % self.players().length;
        return next;
    }
}
