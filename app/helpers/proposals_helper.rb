module ProposalsHelper
  def proposal_title(total_votes, username)
    title_text = (total_votes > 0) ? 'Proposed by ' : 'Improvement by '
    content_tag(:h4, raw('&mdash; ') + title_text + username)
  end
end
