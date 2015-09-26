window.App = new ( Backbone.Router.extend({

  routes: {
    "":                  "index",
    "index":             "index",
  }

  start: ->
    this.set_user_uuid()

    $('a').click (e) ->
      e.preventDefault()
      Backbone.history.navigate(e.target.pathname, { trigger: true })

    Backbone.history.start({pushState: true }) unless Backbone.History.started

  set_user_uuid: ->
    window.App.uuid = $("#uuid").attr("uuid")

  index: ->
    this.kanjiView = new KanjiView({ model: this.kanji })

    this.tasks = new Tasks()
    this.reviewView = new ReviewView({ collection: this.tasks, kanji_view: this.kanjiView })

    $('#review-container').html(this.reviewView.el)
    this.navigationView = new NavigationView({ review_view: this.reviewView })
    $('#navigation-container').html(this.navigationView.el)

    this.navigationView.render()

}))
