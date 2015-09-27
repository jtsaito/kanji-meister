window.NavigationView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'navigation'
  id:        'navigation-view'

  template:  ->
    _.template( $("#navigation").html() )

  render: () ->
    this.$el.html(this.template()())

    this

  events: {
    "click a#root" : "root"
    "click a#fetch_review_tasks" : "fetch_review_tasks"
    "click a#fetch_unreviewed_tasks" : "fetch_unreviewed_tasks"
  }

  root: ->
    window.App.navigate("", {trigger: true})

  fetch_review_tasks: ->
    window.App.navigate("review", {trigger: true})

  fetch_unreviewed_tasks: ->
    window.App.navigate("learn_new", {trigger: true})
})
