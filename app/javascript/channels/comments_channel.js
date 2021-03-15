import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  if (/questions\/\d+/.test(window.location.pathname)) {

    let template = require('./templates/comment.hbs')
    consumer.subscriptions.create({channel: "CommentsChannel"}, {

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