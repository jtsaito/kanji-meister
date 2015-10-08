window.KanjiComment = Backbone.Model.extend(
  defaults:
    id: 0
    text: null

  idAttribute: "_id"

  url: ->
    if this.id != null
      "/api/v1/users/#{window.App.uuid}/kanjis/#{this.get("kanji_character")}/kanji_comments"
    else
      "/api/v1/users/#{window.App.uuid}/kanjis/#{this.get("kanji_character")}/kanji_comments/#{this.get('id')}"

  toJSON: () ->
    _.clone( this.attributes )

)
