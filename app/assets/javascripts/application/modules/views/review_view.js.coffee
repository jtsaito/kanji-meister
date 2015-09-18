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

  set_kanji_to_first: ->
    kanji = this.get_kanji(0)
    this.kanji_view.trigger("kanji_updated", kanji)

  fetch_new_kanji: ->
    this.index = 0
    this.model.task_type = "present_new"

    this.model.fetch({
      success: (model, response) ->
        window.App.reviewView.render()
        window.App.reviewView.set_kanji_to_first()
    })

  fetch_review_kanji: ->
    this.index = 0
    this.model.task_type = "review"

    this.model.fetch({
      success: (model, response) ->
        window.App.reviewView.render()
        window.App.reviewView.set_kanji_to_first()
    })

})
