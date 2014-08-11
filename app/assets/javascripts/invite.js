Invite = function (email, isAccepted, isDeclined, revokeUrl) {
    this.email = email;
    this._accepted = isAccepted;
    this._declined = isDeclined;
    this.revokeUrl = ko.observable(revokeUrl);

    this.isAccepted = function() { return this._accepted; }
    this.isDeclined = function() { return this._declined; }
    this.isOpen = function() { return !this._accepted && !this._declined; }
}
