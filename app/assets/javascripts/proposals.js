(function () {

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
      proposal_id = proposal_container.data('proposal_id'),
      editableBox = proposal_container.find('.content_editable'),
      improve_support_buttons = proposal_container.find('.improve_support_buttons'),
      proposal_form_buttons = proposal_container.find('.proposal_form_buttons');

    // Are we in Improve, Reuse or Edit?
    if (el.hasClass('reuse')) {
      $('.save_statement').html('Reuse this proposal');
      $('.improve_form').addClass('reuse_proposal_form').removeClass('.improve_form');
      app.configureHubFilter('#proposal_group_name', '544px');
      el.closest('.proposal_container').find('.proposal_fields').removeClass('hide');
    } else if (el.hasClass('edit')) {
      // reconfirm that this is still editable
      $.get('/proposals/'+proposal_id+'/isEditable.json')
      .done(function(data) {
        if (data.editable) {
          $('.save_statement').html('Save Edit');
          $('.improve_form').addClass('edit_proposal_form').removeClass('.improve_form');
        } else {
          hideContentEditable(el);
          var improve_support_buttons = proposal_container.find('.improve_support_buttons');
          improve_support_buttons.find('.edit').removeClass('edit').addClass('support').text('Support');
          improve_support_buttons.find('.delete').removeClass('delete btn-danger').addClass('improve btn-warning').text('Improve');
          app.errorMessage('After you loaded this page, new votes came in and made the proposal uneditable');
        }
      });
    }
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
      if (!app.loginInterrupt(this, showImprovement)) {
        return false;
      }
    } else {
      showImprovement(this);
      return false;
    }
  }

  var saveImprovement = function() {
    var el = $(this),
      proposal_container = el.closest('.proposal_container'),
      editableBox = proposal_container.find('.content_editable'),
      proposal_id = proposal_container.data('proposal_id'),
      statement = editableBox.text().trim(),
      proposal_location = $('#proposal_location').val(),
      proposal_hub = $('#proposal_group_name').val(),
      comment = $('#vote_comment').val(),
      // this is not a good way to have user on hand but acceptable to me for first pass
      user_id = $('#user_menu').find('.dropdown-toggle').data('email'),
      proposal_data = {
        proposal: {
          statement: statement,
          user_id: user_id,
          votes_attributes: {user_id: user_id, comment: comment}
        }
      };

    if (proposal_container.find('.edit_proposal_form').length > 0) {
      proposal_data.proposal.id = proposal_id
      proposal_data.proposal.votes_attributes.id = proposal_container.find('.supporting_statement').data('vote_id');
      $.ajax({
        url: '/proposals/'+proposal_id+'.json',
        type: 'PUT',
        data: proposal_data
      })
      .done(function(data) {
        hideContentEditable(el);
        proposal_container.find('.proposal_statement h3').html(data.statement);
        proposal_container.find('.supporting_statement').html(data.supporting_statement);
      })
      .fail(function(data) {
        app.errorMessage(data.responseText);
      });
    } else {
      if (proposal_container.find('.reuse_proposal_form').length > 0) {
        proposal_data.proposal.proposal_hub = proposal_hub;
        proposal_data.proposal.proposal_location = proposal_location;
      } else {
        proposal_data.proposal.parent_id = proposal_id;
      }
      $.post('/proposals', proposal_data)
      .done(function(data) {
        hideContentEditable(el);
      })
      .fail(function(data) {
        app.errorMessage(data.responseText);
      });
    }
  }

  var deleteProposal = function(e) {
    e.preventDefault();
    var el = $(this),
        proposal_container = $(this).closest('.proposal_container'),
        proposal_id = proposal_container.data('proposal_id'),
        improve_support_buttons;

    // reconfirm that this is still deletable
    $.get('/proposals/'+proposal_id+'/isEditable.json')
    .done(function(data) {
      if (data.editable) {
        $('#confirmationModalQuestion').html('Are you sure you want to delete this Proposal?');
        $('#confirmationModalExplanation').html('Please note that deleting a proposal is permanent and cannot be undone');
        $('#confirmationModal').modal('show');
        $('#confirmationModalYes').on('click', function(e) {
          e.preventDefault();
          $.ajax({
            url: '/proposals/'+proposal_id,
            type: 'DELETE',
            data: {proposal: {id: proposal_id}}
          })
          .success(function(data) {
            window.location.assign('/proposals');
          })
          .fail(function(data) {
            alert('This proposal could not be deleted');
            $(this).parents('.modal').modal('hide');
          });
        });
      } else {
        hideContentEditable(el);
        improve_support_buttons = proposal_container.find('.improve_support_buttons');
        improve_support_buttons.find('.edit').removeClass('edit').addClass('support').text('Support');
        improve_support_buttons.find('.delete').removeClass('delete btn-danger').addClass('improve btn-warning').text('Improve');
        app.errorMessage('After you loaded this page, new votes came in and made the proposal uneditable');
      }
    });
  }

  var showSupport = function(self) {
    var el = $(self),
      proposal_container = el.closest('.proposal_container'),
      improve_support_buttons = proposal_container.find('.improve_support_buttons'),
      proposal_person = $('.support_container').find('.proposal-person'),
      user_id = $('#user-dropdown-menu').data('email'),
      user_name = $('#user-dropdown-menu').text();

    proposal_person.find('span').replaceWith('<a href="/users/'+ user_id + '/proposals">' + user_name + '</a>');
    proposal_container.find('.support_container').removeClass('hide').addClass('active');
    proposal_container.find('.vote_comment textarea').val('').focus();
    improve_support_buttons.hide();
  }

  var newSupport = function(e) {
    e.preventDefault();

    if ($('#user-dropdown-menu').length === 0) {
      if (!app.loginInterrupt(this, showSupport)) {
        return;
      }
    } else {
      showSupport(this);
    }
  }

  var updateSupport = function(proposal_container, data) {
    var existing_votes = proposal_container.find('.supporting_arguments .support_row').length > 0,
        sa = proposal_container.find('.supporting_arguments_list'),
        srs = sa.find('.support_row').detach(),
        sform = sa.find('.support_container').detach(),
        newSA = $('<div class="row support_row first' + (existing_votes ? '' : ' first') + '"><div class="proposal-person span3" data-vote_number=""><div class="user-avatar"><img data-src="holder.js/30x30/social/text:avatar" alt="avatar" style="width: 30px; height: 30px;"></div><a href="/proposals?user_id=' + data.user_id + '">' + data.user_name + '</a><div class="supported_date">' + new Date().toLocaleDateString() + '</div></div><div class="support_comment span8">' + data.comment + '</div></div>'),
        newSupports = [sform];

    newSupports.push(newSA);
    if (existing_votes) {
      srs.each(function() {
        $(this).removeClass('first');
        newSupports.push(this);
      });
    }
    sa.prepend(newSupports);
    Holder.run(); // updates the placeholder images
    if (!existing_votes) { // only unhide these when new vote is only Supporting vote
      proposal_container.find('.supporting_arguments h3').removeClass('hide');
      proposal_container.find('.supporting_arguments .support_row').removeClass('hide');
    }
  }

  var saveVote = function(e) {
    e.preventDefault();
    var el = $(this),
      proposal_container = el.closest('.proposal_container'),
      proposal_id = proposal_container.data('proposal_id'),
      comment = proposal_container.find('.vote_comment textarea').val(),
      // this is not a good way to have user on hand but acceptable to me for first pass
      hub_id = proposal_container.data('hub_id');
    
    $.post('/votes.json', {vote: {proposal_id: proposal_id, comment: comment}})
      .success(function(data) {
        hideContentEditable(el);
        updateSupport(proposal_container, data);
        app.successMessage('Thanks. Your vote has been counted!');
      }).
      error(function(data) {
        var responseText = data.responseText,
            msg = $.parseJSON(data.responseText);

        if (data.responseText.indexOf("You can only vote once on a proposal") > -1) {
          app.errorMessage(msg.user_id);
        }
      });
  }

  $(document).ready(function() {
    $('.more').click(showMore);
    $('.improve, .edit, .reuse').click(newImprovement);
    $('.delete').click(deleteProposal);
    $('.support').on('click', newSupport);
    $('.save_statement').on('click', saveImprovement);
    $('.save_vote').on('click', saveVote);
    $('.cancel').on('click', function(e) {
      e.preventDefault();
      hideContentEditable($(this));
    });
    app.updateSearchFields({hub: $('.proposal_hub').text().trim().replace(/\n/g, '').split('    –    ')});
    if ($('#new_proposal').length > 0) {
      app.configureHubFilter('#group_name', '544px');
    }
  });

})();
