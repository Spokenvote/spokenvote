var hideContentEditable = function(el) {
  var activeForm = el.closest('.active'),
    editableBox = activeForm.find('.content_editable'),
    improve_support_buttons = activeForm.parents('.proposal_container').find('.improve_support_buttons')

  if (editableBox.length > 0) {
    // restored saves original value
    editableBox.attr('contenteditable', 'false').html(editableBox.data('original'));
    activeForm.parent().find('.proposal_statement').toggle();
    if (!activeForm.find('.proposal_fields').hasClass('hide')) {
      activeForm.find('.proposal_fields').addClass('hide');
    }
  }
  activeForm.removeClass('active').addClass('hide');
  improve_support_buttons.show();
}

var showMore = function(e) {
  e.preventDefault();
  var el = $(this).find('a'),
    url = el.attr('href');

  $.get(url, function(data) {
    el.closest('.proposal_container').find('.supporting_arguments_list').append(data);
    Holder.run(); // updates the placeholder images

    if (data.match(/hide_the_more_link/)) {
      el.closest('.proposal_container').find('.more').hide();
    } else {
      var matches = decodeURIComponent(url).match(/(page:)(\d)(.*)/);

      if (matches) {
        page_prefix = matches[1];
        page_number = matches[2];
        the_rest = matches[3];
        newUrl = page_prefix + (parseInt(page_number) + 1) + the_rest
        el.attr('href', window.location + '?context=' + newUrl);
      }
    }
  });
}

var showImprovement = function(self) {
  var el = $(self),
    proposal_container = el.closest('.proposal_container'),
    editableBox = proposal_container.find('.content_editable'),
    improve_support_buttons = proposal_container.find('.improve_support_buttons'),
    proposal_form_buttons = proposal_container.find('.proposal_form_buttons');

  // first bit save original value so we can restore on cancel
  editableBox.data('original', editableBox.html().trim()).attr('contenteditable', 'true');
  proposal_container.find('.improve_form').removeClass('hide').addClass('active');
  proposal_container.find('.proposal_statement').toggle();
  improve_support_buttons.hide();
  proposal_form_buttons.show();
}

var newImprovement = function(e) {
  e.preventDefault();
  
  // not logged in?
  if ($('#user-dropdown-menu').length === 0) {
    if (!loginInterrupt(showImprovement, this)) {
      return;
    }
  } else {
    showImprovement(this);
  }

}

var saveImprovement = function() {
  var el = $(this),
    proposal_container = el.closest('.proposal_container'),
    editableBox = proposal_container.find('.content_editable'),
    proposal_id = proposal_container.data('proposal-id'),
    url = '/proposals/' + proposal_id,
    new_value = editableBox.text().trim();

  console.log(el);

  $.ajax({
    url: url,
    type: 'PUT',
    dataType: 'json',
    data: {
      proposal: {
        statement: new_value
      }
    },
    success: function(data) {
      hideContentEditable(el);
    }
  });
}

var showSupport = function(self) {
  var el = $(self),
    proposal_container = el.closest('.proposal_container'),
    improve_support_buttons = proposal_container.find('.improve_support_buttons');

  proposal_container.find('.support_form').removeClass('hide').addClass('active');
  proposal_container.find('.vote_comment input').val('');
  improve_support_buttons.hide();

}

var newSupport = function(e) {
  e.preventDefault();

  if ($('#user-dropdown-menu').length === 0) {
    if (!loginInterrupt(showSupport, this)) {
      return;
    }
  } else {
    showImprovement(this);
  }
}

var updateSupport = function(proposal_container, data) {
  var sa = proposal_container.find('.supporting_arguments .span11'),
      newSA = '<div class="span2 proposal-person">3: ' + data.user_name + '</div><div class="span8">' + data.comment.substr(0,140) + (data.commentlength > 140 ? '...more' : '') + '</div><div class="hide_the_more_link">&nbsp;</div>';
  sa.append(newSA);
}

var saveVote = function(e) {
  e.preventDefault();
  var el = $(this),
    proposal_container = el.closest('.proposal_container'),
    proposal_id = proposal_container.data('proposal_id'),
    comment = proposal_container.find('.vote_comment input').val(),
    // this is not a good way to have user on hand but acceptable to me for first pass
    user_id = $('#user_menu').find('.dropdown-toggle').data('email'),
    hub_id = proposal_container.data('hub_id');
  
  $.post('/votes.json', {vote: {proposal_id: proposal_id, comment: comment, user_id: user_id, hub_id: hub_id}})
    .success(function(data) {
      // did we create new vote?
      console.log('in support callback')
      hideContentEditable(el);
      updateSupport(proposal_container, data);
      successMessage('Vote was successfully created');
    }).
    error(function(data) {
      console.log('in saveVote error function:' + data.responseText);
      if (data.responseText.indexOf("Can't vote on the same issue twice") > -1) {
        alert('You can only vote once on a proposal');
      }
    });
}

$(document).ready(function() {
  $('.more').click(showMore);
  $('.improve').click(newImprovement);
  $('.cancel').on('click', function(e) {
    e.preventDefault();
    hideContentEditable($(this));
  });
  $('.retarget_proposal').on('click', function(e) {
    e.preventDefault();
    $(this).closest('.proposal_container').find('.proposal_fields').removeClass('hide');
  });
  $('.support').on('click', newSupport);
  $('.save_statement').on('click', saveImprovement);
  $('.save_vote').on('click', saveVote);
  updateSearchFields({hub: $('.proposal_hub').text().trim().split(' &ndash; ')});
});
