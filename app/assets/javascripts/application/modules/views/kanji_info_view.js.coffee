window.KanjiInfoView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'kanji'
  id:        'kanji-info-view'

  template:  ->
    _.template( $("#review-info").html() )

  render: () ->
    this.$el.html(this.template()(this.model.attributes))

    this

})