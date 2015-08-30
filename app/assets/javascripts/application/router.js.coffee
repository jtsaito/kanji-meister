window.App = new ( Backbone.Router.extend({

  routes: {
    "":                  "index",
    "index":             "index",
  }

  start: ->
    $('a').click (e) ->
      e.preventDefault()
      Backbone.history.navigate(e.target.pathname, { trigger: true })

    Backbone.history.start({pushState: true }) unless Backbone.History.started

  index: ->
    this.kanji = new Kanji({id: 17})
    this.kanjiView = new KanjiView( { model: this.kanji } )

    $('#app').html(this.kanjiView.el)

    this.kanji.fetch({
      success: (model, response) ->
        window.App.kanjiView.render()
    })

}))

