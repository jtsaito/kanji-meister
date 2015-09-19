window.Kanji = Backbone.Model.extend(
  idAttribute: "_id"

  urlRoot: '/api/v1/kanjis'

  defaults:
    heisig_id: "0"
)
