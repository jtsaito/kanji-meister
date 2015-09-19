window.Event = Backbone.Model.extend(
  idAttribute: "_id"

  urlRoot: '/api/v1/events'

  toJSON: () ->
    event: _.clone( this.attributes )

  defaults:
    name: ""
)
