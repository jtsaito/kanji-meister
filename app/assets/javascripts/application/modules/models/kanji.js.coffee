window.Kanji = Backbone.Model.extend({
  idAttribute: "_id",
  urlRoot: '/api/v1/kanjis/:_id?random=true',
  defaults: { heisig_id: "0" }
})
