Row = function() {
    this.columns = [];

    this.addColumn = function(cssClass, player) {
        this.columns.push(new Column(cssClass, player));
    }
}
