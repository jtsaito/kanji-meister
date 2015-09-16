window.Tasks = Backbone.Collection.extend(
  model: window.Task

  url: ->
    '/api/v1/users/' + window.App.uuid + '/tasks'
)
