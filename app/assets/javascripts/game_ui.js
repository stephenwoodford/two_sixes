GameUI = function(game) {
    var self = this;
    this.game = game;
    this.$numberInput = $("#number");
    this.$faceValueInput = $("#face_value");

    this.init = function() {
        $("#bid").on("click", function(){
            var number = parseInt(self.$numberInput.val());
            var faceValue = parseInt(self.$faceValueInput.val());
            var bid = new Bid(number, faceValue);

            self.game.bid(bid);
        });
        $("#plusOne").on("click", function(){
            var bid = game.currentBid().plusOne();

            self.game.bid(bid);
        });
        $("#bs").on("click", function(){
            self.game.bs();
        });
    }
}
