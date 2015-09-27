window.App = new ( Backbone.Router.extend({

  routes:
    "":          "index",
    "index":     "index",
    "review":    "review",
    "learn_new": "learn_new"

  start: ->
    this.set_user_uuid()

    $('a').click (e) ->
      e.preventDefault()
      Backbone.history.navigate(e.target.pathname, { trigger: true })

    Backbone.history.start({pushState: true }) unless Backbone.History.started

  set_user_uuid: ->
    window.App.uuid = $("#uuid").attr("uuid")

  setup_views: ->
    this.kanjiView = new KanjiView({ model: this.kanji })

    this.tasks = new Tasks()
    this.reviewView = new ReviewView({ collection: this.tasks, kanji_view: this.kanjiView })

  index: ->
    this.indexView = new IndexView()
    $('#review-container').html(this.indexView.el)
    this.indexView.render()

    this.navigationView = new NavigationView()
    $('#navigation-container').html(this.navigationView.el)
    this.navigationView.render()

  review: ->
    this.setup_views()
    $('#review-container').html(this.reviewView.el)
    this.reviewView.fetch_tasks("review")

  learn_new: ->
    this.setup_views()
    $('#review-container').html(this.reviewView.el)
    this.reviewView.fetch_tasks("introduction")

}))
