'use strict';

var Elm = require('./Main.elm');
var app = Elm.Main.embed(document.getElementById('main'));

const req = require.context('./Styles', true, /\.css$/);

app.ports.fetchClasses.subscribe(function(cssFile) {
  const styles = req(cssFile);

  setImmediate(function() {
    app.ports.receiveClasses.send(styles);
  });
});
