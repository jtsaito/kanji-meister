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
    this.listenTo(this.kanji_view, 'clicked-result', this.increment_index)

  template: ->
    _.template( $("#review").html() )

  render: () ->
    kanji_list = this.collection.map( (it) ->
      it.kanji().get("key_word")
    ).join(", ")

    this.$el.html(this.template()({ "kanji_list": kanji_list }))
    this

  events: {
    "click a#next-review-item" : "increment_index"
  }

  increment_index: ->
    new_index = (this.index + 1) % this.collection.length
    this.set_index(new_index)

  fetch_tasks: (task_type) ->
    this.collection.set_task_type_and_fetch(task_type)

  collection_updated: ->
    this.set_index(0)
    this.render()

  set_index: (index) ->
    this.index = index

    kanji = this.collection.at(this.index).kanji()
    this.kanji_view.trigger("kanji_updated", kanji)

})
