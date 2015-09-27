window.NavigationView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'navigation'
  id:        'navigation-view'

  template: ->
    _.template( $("#navigation").html() )

  render: ->
    this.$el.html(this.template()())

    this

  events: {
    "click a#root" : "root"
    "click a#fetch_review_tasks" : "fetch_review_tasks"
    "click a#fetch_unreviewed_tasks" : "fetch_unreviewed_tasks"
    "click li.nav-list" : "set_active_navigation"
  }

  set_active_navigation: (event) ->
    this.$(".nav-list").removeClass("active")
    this.$(event.currentTarget).addClass("active")

  root: ->
    window.App.navigate("", {trigger: true})

  fetch_review_tasks: ->
    window.App.navigate("review", {trigger: true})

  fetch_unreviewed_tasks: ->
    window.App.navigate("learn_new", {trigger: true})
})
