window.Task = Backbone.Model.extend(
  defaults:
    kanji: null

  kanji: ->
    new Kanji(this.get("kanji"))
)
