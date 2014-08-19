Bid = function (number, faceValue) {
    this.number = number;
    this.faceValue = faceValue;

    this.plusOne = function() {
        return new Bid(this.number + 1, this.faceValue);
    }

    this.to_string = function() {
        var ret = this.number + " " + this.faceValue;
        if (this.number != 1)
            ret += "s";
        return ret;
    }
}
