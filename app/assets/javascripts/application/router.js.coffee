window.App = new ( Backbone.Router.extend({

  routes: {
    "":                  "index",
  }

  start: ->
    $('a').click (e) ->
      e.preventDefault()
      Backbone.history.navigate(e.target.pathname, { trigger: true })

    Backbone.history.start({pushState: true }) unless Backbone.History.started


}))

