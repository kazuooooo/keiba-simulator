(function(){ActiveAdmin.CheckboxToggler=function(){function t(t,e){var i;this.options=t,this.container=e,i={},this.options=$.extend(i,this.options),this._init(),this._bind()}return t.prototype._init=function(){if(!this.container)throw new Error("Container element not found");if(this.$container=$(this.container),!this.$container.find(".toggle_all").length)throw new Error('"toggle all" checkbox not found');return this.toggle_all_checkbox=this.$container.find(".toggle_all"),this.checkboxes=this.$container.find(":checkbox").not(this.toggle_all_checkbox)},t.prototype._bind=function(){return this.checkboxes.change(function(t){return function(e){return t._didChangeCheckbox(e.target)}}(this)),this.toggle_all_checkbox.change(function(t){return function(){return t._didChangeToggleAllCheckbox()}}(this))},t.prototype._didChangeCheckbox=function(t){switch(this.checkboxes.filter(":checked").length){case this.checkboxes.length-1:return this.toggle_all_checkbox.prop({checked:null});case this.checkboxes.length:return this.toggle_all_checkbox.prop({checked:!0})}},t.prototype._didChangeToggleAllCheckbox=function(){var t;return t=this.toggle_all_checkbox.prop("checked")?!0:null,this.checkboxes.each(function(e){return function(i,n){return $(n).prop({checked:t}),e._didChangeCheckbox(n)}}(this))},t}(),$.widget.bridge("checkboxToggler",ActiveAdmin.CheckboxToggler)}).call(this);