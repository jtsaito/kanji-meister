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
    this.listenTo(this.kanji_view, 'kanji-clicked', this.clicked)

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
    "click a#learned" : "learned"
    "click a#not_learned" : "not_learned"
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

  # kanji stuff
  learned: ->
    this.post_kanji_reviewed_event(correct: true)
    this.kanji_view.trigger("clicked-result")

  not_learned: ->
    this.post_kanji_reviewed_event(correct: false)
    this._view.trigger("clicked-result")

  clicked: (e) ->
    this.kanji_view.toggle_show_kanji()
    this.kanji_view.render()

  show_kanji_buttons: ->
    console.log "show kanji buttons? #{this.kanji_view.show_kanji}"
    this.kanji_view.show_kanji

  post_kanji_reviewed_event: (result) ->
    new Event(
      name: "kanji_reviewed"
      user_uuid: window.App.uuid
      payload:
        kanji: this.kanji_view.model.kanji
        kanji_attributes: this.kanji_view.model.attributes
        result: result
    ).save()

})
