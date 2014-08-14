Bid = function (number, faceValue) {
    this.number = number;
    this.faceValue = faceValue;

    this.plusOne = function() {
        return new Bid(this.number + 1, this.faceValue);
    }

    this.to_string = function() {
        return this.number + " " + this.faceValue + "s";
    }
}
