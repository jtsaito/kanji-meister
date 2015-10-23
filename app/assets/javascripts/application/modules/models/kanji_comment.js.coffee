window.KanjiComment = Backbone.Model.extend(
  defaults:
    id: null
    text: ""

  url: ->
    "/api/v1/users/#{window.App.uuid}/kanjis/#{this.get("kanji_character")}/kanji_comments/#{this.id||''}"

  toJSON: ->
    _.clone( this.attributes )

)
