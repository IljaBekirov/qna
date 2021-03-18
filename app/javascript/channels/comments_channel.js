import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  if (/questions\/\d+/.test(window.location.pathname)) {

    let template = require('./templates/comment.hbs')
    consumer.subscriptions.create("CommentsChannel", {
      connected: function () {
        let question_id = gon.question_id;
        return this.perform('follow', { question_id: question_id});
      },

        received(data) {
          if (gon.current_user_id === data.comment.user_id) return;

          let id = data.comment.commentable_type.toLowerCase() + '_' + data.comment.commentable_id + '_comments'
          let result = template(data)
          document.getElementById(id).innerHTML += result
        }
      }
    );
  }
});