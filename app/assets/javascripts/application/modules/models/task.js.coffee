window.Task = Backbone.Model.extend(
  defaults:
    kanji: null

  kanji: ->
    new Kanji(this.get("kanji"))

  add_and_fetch_kanji_comment: (kanji_comment) ->
    this["kanji_comment"] = kanji_comment
    this.comment().fetch()
    this.comment()

  comment: ->
    this["kanji_comment"]
)
