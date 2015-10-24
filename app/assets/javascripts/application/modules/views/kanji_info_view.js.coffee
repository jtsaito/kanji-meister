window.KanjiInfoView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'kanji'
  id:        'kanji-info-view'

  initialize: ->
    this.model = new Kanji()

  template: ->
    _.template( $("#review-info").html() )

  jisho_url: ->
    encoded_kanji = encodeURIComponent(this.model.get("kanji"))
    "http://jisho.org/word/#{encoded_kanji}"

  render: ->
    attributes = _.extend(this.model.attributes, { "jisho_url": this.jisho_url() } )
    this.$el.html(this.template()(attributes))

    this
})
