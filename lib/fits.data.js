// Generated by CoffeeScript 1.3.3
(function() {
  var Data, Module,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Module = require('./fits.module');

  Data = (function(_super) {

    __extends(Data, _super);

    function Data(view, header) {
      this.view = view;
      this.begin = this.current = view.tell();
      this.length = void 0;
    }

    return Data;

  })(Module);

  if (typeof module !== "undefined" && module !== null) {
    module.exports = Data;
  }

}).call(this);