window.Tasks = Backbone.Collection.extend(
  model: window.Task

  initialize: ->
    this.task_type = "review"

  url: ->
    url = '/api/v1/users/' + window.App.uuid + '/tasks'

    url += '?only_new=true' if this.task_type != "review"

    url

  set_task_type_and_fetch: (task_type) ->
    this.task_type = task_type
    this.fetch({
      reset: true,
      success: this.fetch_kanji_comments
    })

  fetch_kanji_comments: (tasks) ->
    _.each(tasks.models, (task) ->
      kanji = task.kanji().get("kanji")

      kanji_comment = new window.KanjiComment({kanji_character: kanji})

      kanji_comment.fetch({
        success: (fetched_comment) ->
          task.add_and_fetch_kanji_comment(kanji_comment)
        error: (error) ->
          if arguments[1].status == 404
            kanji_comment.save(null,{ type: "post"})
      })

    )

)
