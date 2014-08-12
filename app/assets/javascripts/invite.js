Invite = function (obj) {
    this.email = obj["email"];
    this._accepted = ko.observable(obj["isAccepted"]);
    this._declined = ko.observable(obj["isDeclined"]);
    this.revokeUrl = ko.observable(obj["revokeUrl"]);

    this.isAccepted = ko.computed(function() { return this._accepted(); }, this);
    this.isDeclined = ko.computed(function() { return this._declined(); }, this);
    this.isOpen = ko.computed(function() { return !this._accepted() && !this._declined(); }, this);

    this.accept = function() { this._accepted(true); this._declined(false); }
    this.decline = function() { this._accepted(false); this._declined(true); }
}
