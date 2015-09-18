window.NavigationView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'navigation'
  id:        'navigation-view'

  initialize: (attrs) ->
    this.review_view = attrs["review_view"]
    this.review_view.on("new_items_updated", this.review_view.fetch_new_kanji)
    this.review_view.on("review_items_updated", this.review_view.fetch_review_kanji)

  template:  ->
    _.template( $("#navigation").html() )

  render: () ->
    this.$el.html(this.template()({foo: "foo"}))
    this

  events: {
    "click a#new-items" : "new_items"
    "click a#review-items" : "review_items"
  }

  new_items: ->
    this.review_view.trigger("new_items_updated")

  review_items: ->
    this.review_view.trigger("review_items_updated")

})
