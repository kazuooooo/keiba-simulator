(function(){var t=function(t,i){function n(){this.constructor=t}for(var s in i)e.call(i,s)&&(t[s]=i[s]);return n.prototype=i.prototype,t.prototype=new n,t.__super__=i.prototype,t},e={}.hasOwnProperty;ActiveAdmin.TableCheckboxToggler=function(e){function i(){return i.__super__.constructor.apply(this,arguments)}return t(i,e),i.prototype._init=function(){return i.__super__._init.apply(this,arguments)},i.prototype._bind=function(){return i.__super__._bind.apply(this,arguments),this.$container.find("tbody td").click(function(t){return function(e){return"checkbox"!==e.target.type?t._didClickCell(e.target):void 0}}(this))},i.prototype._didChangeCheckbox=function(t){var e;return i.__super__._didChangeCheckbox.apply(this,arguments),e=$(t).parents("tr"),t.checked?e.addClass("selected"):e.removeClass("selected")},i.prototype._didClickCell=function(t){return $(t).parent("tr").find(":checkbox").click()},i}(ActiveAdmin.CheckboxToggler),$.widget.bridge("tableCheckboxToggler",ActiveAdmin.TableCheckboxToggler)}).call(this);