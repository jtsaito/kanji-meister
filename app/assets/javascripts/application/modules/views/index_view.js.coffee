window.IndexView = Backbone.View.extend({

  # new element's attributes
  tagName:   'div'
  className: 'kanji'
  id:        '#review-container'

  template:  ->
    _.template( $("#index").html() )

  render: () ->
    this.$el.html(this.template()())

    this

})
