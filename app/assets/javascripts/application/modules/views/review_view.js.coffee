window.ReviewView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'review'
  id:        'review-view'

  initialize: (attrs) ->
    this.kanji_view = attrs["kanji_view"]
    this.kanji_view.on("kanji_updated", this.kanji_view.kanji_updated)
    this.index = 0

  template: ->
    _.template( $("#review").html() )

  get_kanji: (index) ->
    this.model.models[index].kanji()

  models: ->
    this.model.models

  render: () ->
    stuff = _.map(this.model.models, (it) ->
      it.kanji().get("kanji")
    )

    this.$el.html(this.template()({ "foo": stuff }))
    this

  events: {
    "click a#next-review-item" : "next_review_item"
  }

  increment_index: ->
    this.index = (this.index + 1) % this.model.models.length

  next_review_item: ->
    this.increment_index()
    kanji = this.get_kanji(this.index)
    this.kanji_view.trigger("kanji_updated", kanji)

})
