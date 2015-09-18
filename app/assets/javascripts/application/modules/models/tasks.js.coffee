window.Tasks = Backbone.Collection.extend(
  model: window.Task

  initialize: ->
    this.task_type = "review"

  url: ->
    url = '/api/v1/users/' + window.App.uuid + '/tasks'

    url += '?only_new=true' if this.task_type != "review"

    url
)
