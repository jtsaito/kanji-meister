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
    attributes = _.extend(this.model.attributes)

    this.$el.html(this.template()(attributes))

    if this.show_kanji
      $(".kanji-info").show()
    else
      $(".kanji-info").hide()

    this.post_kanji_rendered_event()

    this

  kanji_updated: (kanji) ->
    this.model = kanji
    this.show_kanji = false
    this.render()

  events: {
    "click div.kanji-keyword" : "clicked"
  }

  clicked: (e) ->
    this.trigger("kanji-clicked")

  toggle_show_kanji: ->
    this.show_kanji = if this.show_kanji then false else true

  post_kanji_rendered_event: ->
    new Event(
      name: "kanji_rendered"
      user_uuid: window.App.uuid
      payload:
        kanji: this.model.kanji
        kanji_attributes: this.model.attributes
    ).save()


})
