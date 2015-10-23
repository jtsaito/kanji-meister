window.KanjiCommentView = Backbone.View.extend({

  tagName:   'div'
  className: 'kanji'
  id:        'kanji-comment-view'

  template: ->
    _.template( $("#kanji-comment").html() )

  render:  ->
    task = arguments[0]["task"]

    kanji_comment = task["kanji_comment"]

    text = if kanji_comment then kanji_comment.get("text") else ""

    this.$el.html(this.template()( { text: text } ))

    this

})
