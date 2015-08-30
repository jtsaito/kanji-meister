window.KanjiView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'kanji'
  id:        'kanji-view'

  initialize: ->
    this.show_kanji = false

  template:  ->
    _.template( $("#kanji").html() )

  render: () ->
    key = if this.show_kanji then "kanji" else "key_word"
    rendering = this.model.get(key)
    attributes = _.extend(this.model.attributes, { rendering: rendering })

    this.$el.html(this.template()(attributes))
    this

  events: {
    "click" : "clicked"
  }

  clicked: (e) ->
    this.show_kanji = if this.show_kanji then false else true
    this.render()

})
