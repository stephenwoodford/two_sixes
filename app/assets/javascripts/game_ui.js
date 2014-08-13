GameUI = function(game) {
    var self = this;
    this.game = game;
    this.$numberInput = $("#number");
    this.$faceValueInput = $("#face_value");

    this.init = function() {
        $("#bid").click(function(){
            var number = parseInt(self.$numberInput.val());
            var faceValue = parseInt(self.$faceValueInput.val());
            var bid = new Bid(number, faceValue);

            self.game.bid(bid);
        });
        $("#plusOne").click(function(){
            var bid = game.currentBid().plusOne();

            self.game.bid(bid);
        });
        $("#bs").click(function(){
            self.game.bs();
        });
    }
}
