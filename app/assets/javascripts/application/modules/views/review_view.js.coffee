window.ReviewView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'review'
  id:        'review-view'

  initialize: (attrs) ->
    this.index = 0

    this.kanji_view = attrs["kanji_view"]
    this.kanji_view.on("kanji_updated", this.kanji_view.kanji_updated)

    this.listenTo(this.collection, 'reset', this.collection_updated)

  template: ->
    _.template( $("#review").html() )

  get_kanji: (index) ->
    this.collection.at(index).kanji()

  render: () ->
    kanji_list = this.collection.map( (it) ->
      it.kanji().get("kanji")
    )

    this.$el.html(this.template()({ "kanji_list": kanji_list }))
    this

  events: {
    "click a#next-review-item" : "next_review_item"
  }

  increment_index: ->
    this.index = (this.index + 1) % this.collection.length

  next_review_item: ->
    this.increment_index()
    kanji = this.get_kanji(this.index)
    this.kanji_view.trigger("kanji_updated", kanji)

  set_kanji_to_first: ->
    kanji = this.get_kanji(0)
    this.kanji_view.trigger("kanji_updated", kanji)

  fetch_tasks: (task_type) ->
    console.log task_type
    this.collection.set_task_type_and_fetch(task_type)

  collection_updated: ->
    this.index = 0
    this.set_kanji_to_first()
    this.render()

})
