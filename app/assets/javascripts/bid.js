Bid = function (number, faceValue) {
    this.number = number;
    this.faceValue = faceValue;

    this.plusOne = function() {
        return new Bid(this.number + 1, this.faceValue);
    }

    this.toString = function() {
        var ret = this.number + " " + this.faceValue;
        if (this.number != 1)
            ret += "s";
        return ret;
    }

    this.toDice = function() {
        return this.number + ' ' + DICE_ICONS[this.faceValue];
    };
}
