var Chat = function() {
    this.comments = ko.observableArray();

    this.add = function(player, message) {
        this.comments.push(new Comment(player, message));
    };
};

var Comment = function(player, message) {
    this.player = player;
    this.message = message;
};
