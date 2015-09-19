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

    this.post_kanji_rendered_event()

    this.$el.html(this.template()(attributes))
    this

  events: {
    "click a#learned" : "learned"
    "click a#not_learned" : "not_learned"
    "click div.kanji" : "clicked"
  }

  kanji_updated: (kanji) ->
    this.model = kanji
    this.show_kanji = false
    this.render()

  learned: ->
    this.post_kanji_reviewed_event(correct: true)

  not_learned: ->
    this.post_kanji_reviewed_event(correct: false)

  clicked: (e) ->
    this.show_kanji = if this.show_kanji then false else true
    this.render()

  post_kanji_rendered_event: ->
    new Event(
      name: "kanji_rendered"
      user_uuid: window.App.uuid
      payload:
        kanji: this.model.kanji
        kanji_attributes: this.model.attributes
    ).save()

  post_kanji_reviewed_event: (result) ->
    new Event(
      name: "kanji_reviewed"
      user_uuid: window.App.uuid
      payload:
        kanji: this.model.kanji
        kanji_attributes: this.model.attributes
        result: result
    ).save()

})
