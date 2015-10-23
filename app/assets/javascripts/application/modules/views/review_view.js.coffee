window.ReviewView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'review'
  id:        'review-container'

  initialize: (attrs) ->
    this.collection = new Tasks()
    this.index = 0

    this.kanji_view = attrs["kanji_view"]
    this.kanji_view.on("kanji_updated", this.kanji_view.kanji_updated)

    this.listenTo(this.collection, 'reset', this.collection_updated)
    this.listenTo(this.kanji_view, 'clicked-result', this.increment_index)

    this.kanji_info_view = new KanjiInfoView()
    this.kanji_comment_view = new KanjiCommentView()

  template: ->
    _.template( $("#review").html() )

  events: {
    "click a#next-review-item" : "increment_index"
    "click a#learned" : "learned"
    "click a#not_learned" : "not_learned"
    "click div.kanji-keyword" : "kanji_clicked"
    "change textarea": "update_text_from_user_input"
  }

  render: ->
    kanji_list = this.collection.map( (it) ->
      it.kanji().get("key_word")
    ).join(", ")

    this.$el.html(this.template()({ "kanji_list": kanji_list } ))

    this.render_kanji_view()
    this.render_kanji_feedback()
    this.render_kanji_info()
    this.render_kanji_comment_view()

    this

  render_kanji_view: ->
    this.$('#kanji-container').html(this.kanji_view.el)
    this.kanji_view.render()
    this.kanji_view.delegateEvents()

    if this.kanji_view.show_kanji
      this.$(".kanji-info").show()
    else
      this.$(".kanji-info").hide()

  render_kanji_feedback: ->
    if this.kanji_view.show_kanji
      this.$(".learned-btn").show()
      this.$(".nxt-review-btn").hide()
    else
      this.$(".learned-btn").hide()
      this.$(".nxt-review-btn").show()

  render_kanji_info: ->
    this.$('#review-info-container').html(this.kanji_info_view.el)

    if this.kanji_view.show_kanji
      this.kanji_info_view.render()
      this.$(".review-info").show()
    else
      this.$(".review-info").hide()

    this.kanji_info_view.render()

  render_kanji_comment_view: ->
    this.$('#kanji-comment-container').html(this.kanji_comment_view.el)

    this.kanji_comment_view.render({task: this.get_task()})

    if this.kanji_view.show_kanji
      this.$(".review-info").show()
    else
      this.$(".review-info").hide()

  increment_index: ->
    new_index = (this.index + 1) % this.collection.length
    this.set_index(new_index)

  fetch_tasks: (task_type) ->
    this.collection.set_task_type_and_fetch(task_type)

  collection_updated: ->
    this.set_index(0)
    this.kanji_view.show_kanji = false
    this.render()

  set_index: (index) ->
    this.index = index

    kanji = this.get_task().kanji()

    this.kanji_view.trigger("kanji_updated", kanji)

    this.render_kanji_feedback()
    this.kanji_info_view.model = kanji
    this.render_kanji_info()
    this.render_kanji_comment_view()

  get_task: ->
    task = this.collection.at(this.index)

  get_kanji_comment: ->
    this.get_task()["kanji_comment"]

  # kanji stuff
  learned: ->
    this.post_kanji_reviewed_event(correct: true)
    this.kanji_view.trigger("clicked-result")

  not_learned: ->
    this.post_kanji_reviewed_event(correct: false)
    this.kanji_view.trigger("clicked-result")

  kanji_clicked: (e) ->
    this.kanji_view.toggle_show_kanji()
    this.kanji_view.render()

    this.render_kanji_feedback()
    this.render_kanji_info()
    this.render_kanji_comment_view()

  show_kanji_buttons: ->
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

  update_text_from_user_input: (e) ->
    new_text = e.target.value
    kanji_comment = this.get_kanji_comment()
    kanji_comment.set("text", new_text)
    kanji_comment.save()

})
