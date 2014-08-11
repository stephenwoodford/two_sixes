Invite = function (obj) {
    this.email = obj["email"];
    this._accepted = obj["isAccepted"];
    this._declined = obj["isDeclined"];
    this.revokeUrl = ko.observable(obj["revokeUrl"]);

    this.isAccepted = function() { return this._accepted; }
    this.isDeclined = function() { return this._declined; }
    this.isOpen = function() { return !this._accepted && !this._declined; }
}
