window.NavigationView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'navigation'
  id:        'navigation-view'

  initialize: (attrs) ->
    this.review_view = attrs["review_view"]
    this.review_view.on("fetch_tasks", this.review_view.fetch_tasks)

  template:  ->
    _.template( $("#navigation").html() )

  render: () ->
    this.$el.html(this.template()())
    this

  events: {
    "click a#fetch_unreviewed_tasks" : "fetch_unreviewed_tasks"
    "click a#fetch_review_tasks" : "fetch_review_tasks"
  }

  fetch_unreviewed_tasks: ->
    this.review_view.trigger("fetch_tasks", "introduction")

  fetch_review_tasks: ->
    this.review_view.trigger("fetch_tasks", "review")

})
