(function() {
  window.Event = Backbone.Model.extend({
    idAttribute: "_id",
    urlRoot: '/api/v1/events',
    toJSON: function() {
      return {
        event: _.clone(this.attributes)
      };
    },
    defaults: {
      name: ""
    }
  });

}).call(this);
(function() {
  window.Kanji = Backbone.Model.extend({
    idAttribute: "_id",
    urlRoot: '/api/v1/kanjis',
    defaults: {
      heisig_id: "0"
    }
  });

}).call(this);
(function() {
  window.KanjiComment = Backbone.Model.extend({
    defaults: {
      id: null,
      text: "",
      kanji_character: ""
    },
    url: function() {
      return "/api/v1/users/" + window.App.uuid + "/kanjis/" + (this.get("kanji_character")) + "/kanji_comments/" + (this.id || '');
    },
    toJSON: function() {
      return _.clone(this.attributes);
    }
  });

}).call(this);
(function() {
  window.Task = Backbone.Model.extend({
    defaults: {
      kanji: null
    },
    kanji: function() {
      return new Kanji(this.get("kanji"));
    },
    add_and_fetch_kanji_comment: function(kanji_comment) {
      this["kanji_comment"] = kanji_comment;
      this.comment().fetch();
      return this.comment();
    },
    comment: function() {
      return this["kanji_comment"];
    }
  });

}).call(this);
(function() {
  window.Tasks = Backbone.Collection.extend({
    model: window.Task,
    initialize: function() {
      return this.task_type = "review";
    },
    url: function() {
      var url;
      url = '/api/v1/users/' + window.App.uuid + '/tasks';
      if (this.task_type !== "review") {
        url += '?only_new=true';
      }
      return url;
    },
    set_task_type_and_fetch: function(task_type) {
      this.task_type = task_type;
      return this.fetch({
        reset: true,
        success: this.fetch_kanji_comments
      });
    },
    fetch_kanji_comments: function(tasks) {
      return _.each(tasks.models, function(task) {
        var kanji, kanji_comment;
        kanji = task.kanji().get("kanji");
        kanji_comment = new window.KanjiComment({
          kanji_character: kanji
        });
        return kanji_comment.fetch({
          success: function(fetched_comment) {
            return task.add_and_fetch_kanji_comment(kanji_comment);
          },
          error: function(error) {
            if (arguments[1].status === 404) {
              return kanji_comment.save(null, {
                type: "post"
              });
            }
          }
        });
      });
    }
  });

}).call(this);
(function() {
  window.IndexView = Backbone.View.extend({
    tagName: 'div',
    className: 'kanji',
    id: '#review-container',
    template: function() {
      return _.template($("#index").html());
    },
    render: function() {
      this.$el.html(this.template()());
      return this;
    }
  });

}).call(this);
(function() {
  window.KanjiCommentView = Backbone.View.extend({
    tagName: 'div',
    className: 'kanji',
    id: 'kanji-comment-view',
    template: function() {
      return _.template($("#kanji-comment").html());
    },
    render: function() {
      var kanji_comment, task, text;
      task = arguments[0]["task"];
      kanji_comment = task["kanji_comment"];
      text = kanji_comment ? kanji_comment.get("text") : "";
      this.$el.html(this.template()({
        text: text
      }));
      return this;
    }
  });

}).call(this);
(function() {
  window.KanjiInfoView = Backbone.View.extend({
    tagName: 'div',
    className: 'kanji',
    id: 'kanji-info-view',
    initialize: function() {
      return this.model = new Kanji();
    },
    template: function() {
      return _.template($("#review-info").html());
    },
    jisho_url: function() {
      var encoded_kanji;
      encoded_kanji = encodeURIComponent(this.model.get("kanji"));
      return "http://jisho.org/word/" + encoded_kanji;
    },
    render: function() {
      var attributes;
      attributes = _.extend(this.model.attributes, {
        "jisho_url": this.jisho_url()
      });
      this.$el.html(this.template()(attributes));
      return this;
    }
  });

}).call(this);
(function() {
  window.KanjiView = Backbone.View.extend({
    tagName: 'div',
    className: 'kanji',
    id: 'kanji-view',
    initialize: function() {
      return this.show_kanji = false;
    },
    template: function() {
      return _.template($("#kanji").html());
    },
    render: function() {
      var attributes;
      attributes = _.extend(this.model.attributes);
      this.$el.html(this.template()(attributes));
      this.post_kanji_rendered_event();
      this.render_kanji_character();
      return this;
    },
    render_kanji_character: function() {
      if (this.show_kanji) {
        return this.$(".kanji-character").show();
      } else {
        return this.$(".kanji-character").hide();
      }
    },
    kanji_updated: function(kanji) {
      this.model = kanji;
      this.show_kanji = false;
      return this.render();
    },
    toggle_show_kanji: function() {
      return this.show_kanji = this.show_kanji ? false : true;
    },
    post_kanji_rendered_event: function() {
      return new Event({
        name: "kanji_rendered",
        user_uuid: window.App.uuid,
        payload: {
          kanji: this.model.kanji,
          kanji_attributes: this.model.attributes
        }
      }).save();
    }
  });

}).call(this);
(function() {
  window.NavigationView = Backbone.View.extend({
    tagName: 'div',
    className: 'navigation',
    id: 'navigation-view',
    template: function() {
      return _.template($("#navigation").html());
    },
    render: function() {
      this.$el.html(this.template()());
      return this;
    },
    events: {
      "click a#root": "root",
      "click a#fetch_review_tasks": "fetch_review_tasks",
      "click a#fetch_unreviewed_tasks": "fetch_unreviewed_tasks",
      "click li.nav-list": "set_active_navigation"
    },
    set_active_navigation: function(event) {
      this.$(".nav-list").removeClass("active");
      return this.$(event.currentTarget).addClass("active");
    },
    root: function() {
      return window.App.navigate("", {
        trigger: true
      });
    },
    fetch_review_tasks: function() {
      return window.App.navigate("review", {
        trigger: true
      });
    },
    fetch_unreviewed_tasks: function() {
      return window.App.navigate("learn_new", {
        trigger: true
      });
    }
  });

}).call(this);
(function() {
  window.ReviewView = Backbone.View.extend({
    tagName: 'div',
    className: 'review',
    id: 'review-container',
    initialize: function(attrs) {
      this.collection = new Tasks();
      this.index = 0;
      this.kanji_view = attrs["kanji_view"];
      this.kanji_view.on("kanji_updated", this.kanji_view.kanji_updated);
      this.listenTo(this.collection, 'reset', this.collection_updated);
      this.listenTo(this.kanji_view, 'clicked-result', this.increment_index);
      this.kanji_info_view = new KanjiInfoView();
      return this.kanji_comment_view = new KanjiCommentView();
    },
    template: function() {
      return _.template($("#review").html());
    },
    events: {
      "click a#next-review-item": "increment_index",
      "click a#learned": "learned",
      "click a#not_learned": "not_learned",
      "click div.kanji-keyword": "kanji_clicked",
      "change textarea": "update_text_from_user_input"
    },
    render: function() {
      var kanji_list;
      kanji_list = this.collection.map(function(it) {
        return it.kanji().get("key_word");
      }).join(", ");
      this.$el.html(this.template()({
        "kanji_list": kanji_list
      }));
      this.render_kanji_view();
      this.render_kanji_feedback();
      this.render_kanji_info();
      this.render_kanji_comment_view();
      return this;
    },
    render_kanji_view: function() {
      this.$('#kanji-container').html(this.kanji_view.el);
      this.kanji_view.render();
      this.kanji_view.delegateEvents();
      if (this.kanji_view.show_kanji) {
        return this.$(".kanji-info").show();
      } else {
        return this.$(".kanji-info").hide();
      }
    },
    render_kanji_feedback: function() {
      if (this.kanji_view.show_kanji) {
        this.$(".learned-btn").show();
        return this.$(".nxt-review-btn").hide();
      } else {
        this.$(".learned-btn").hide();
        return this.$(".nxt-review-btn").show();
      }
    },
    render_kanji_info: function() {
      this.$('#review-info-container').html(this.kanji_info_view.el);
      if (this.kanji_view.show_kanji) {
        this.kanji_info_view.render();
        this.$(".review-info").show();
      } else {
        this.$(".review-info").hide();
      }
      return this.kanji_info_view.render();
    },
    render_kanji_comment_view: function() {
      this.$('#kanji-comment-container').html(this.kanji_comment_view.el);
      this.kanji_comment_view.render({
        task: this.get_task()
      });
      if (this.kanji_view.show_kanji) {
        return this.$(".review-info").show();
      } else {
        return this.$(".review-info").hide();
      }
    },
    increment_index: function() {
      var new_index;
      new_index = (this.index + 1) % this.collection.length;
      return this.set_index(new_index);
    },
    fetch_tasks: function(task_type) {
      return this.collection.set_task_type_and_fetch(task_type);
    },
    collection_updated: function() {
      this.set_index(0);
      this.kanji_view.show_kanji = false;
      return this.render();
    },
    set_index: function(index) {
      var kanji;
      this.index = index;
      kanji = this.get_task().kanji();
      this.kanji_view.trigger("kanji_updated", kanji);
      this.render_kanji_feedback();
      this.kanji_info_view.model = kanji;
      this.render_kanji_info();
      return this.render_kanji_comment_view();
    },
    get_task: function() {
      var task;
      return task = this.collection.at(this.index);
    },
    get_kanji_comment: function() {
      return this.get_task()["kanji_comment"];
    },
    learned: function() {
      this.post_kanji_reviewed_event({
        correct: true
      });
      return this.kanji_view.trigger("clicked-result");
    },
    not_learned: function() {
      this.post_kanji_reviewed_event({
        correct: false
      });
      return this.kanji_view.trigger("clicked-result");
    },
    kanji_clicked: function(e) {
      this.kanji_view.toggle_show_kanji();
      this.kanji_view.render();
      this.render_kanji_feedback();
      this.render_kanji_info();
      return this.render_kanji_comment_view();
    },
    show_kanji_buttons: function() {
      return this.kanji_view.show_kanji;
    },
    post_kanji_reviewed_event: function(result) {
      return new Event({
        name: "kanji_reviewed",
        user_uuid: window.App.uuid,
        payload: {
          kanji: this.kanji_view.model.kanji,
          kanji_attributes: this.kanji_view.model.attributes,
          result: result
        }
      }).save();
    },
    update_text_from_user_input: function(e) {
      var kanji_comment, new_text;
      new_text = e.target.value;
      kanji_comment = this.get_kanji_comment();
      kanji_comment.set("text", new_text);
      return kanji_comment.save();
    }
  });

}).call(this);
(function() {
  window.App = new (Backbone.Router.extend({
    routes: {
      "": "index",
      "index": "index",
      "review": "review",
      "learn_new": "learn_new"
    },
    start: function() {
      this.set_user_uuid();
      $('a').click(function(e) {
        e.preventDefault();
        return Backbone.history.navigate(e.target.pathname, {
          trigger: true
        });
      });
      if (!Backbone.History.started) {
        return Backbone.history.start({
          pushState: true
        });
      }
    },
    set_user_uuid: function() {
      return window.App.uuid = $("#uuid").attr("uuid");
    },
    setup_views: function() {
      this.kanjiView = new KanjiView();
      return this.reviewView = new ReviewView({
        kanji_view: this.kanjiView
      });
    },
    index: function() {
      this.indexView = new IndexView();
      $('#review-container').html(this.indexView.el);
      this.indexView.render();
      this.navigationView = new NavigationView();
      $('#navigation-container').html(this.navigationView.el);
      return this.navigationView.render();
    },
    review: function() {
      this.setup_views();
      $('#review-container').html(this.reviewView.el);
      return this.reviewView.fetch_tasks("review");
    },
    learn_new: function() {
      this.setup_views();
      $('#review-container').html(this.reviewView.el);
      return this.reviewView.fetch_tasks("introduction");
    }
  }));

}).call(this);
(function() {
  jQuery(function() {
    $("a[rel~=popover], .has-popover").popover();
    return $("a[rel~=tooltip], .has-tooltip").tooltip();
  });

}).call(this);
(function() {


}).call(this);
(function() {


}).call(this);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//
//# require application/lib/jquery-1.12.0.min
//# require application/lib/underscore-min
//# require application/lib/bootstrap
//# require application/lib/app

//# require application/lib/backbone





