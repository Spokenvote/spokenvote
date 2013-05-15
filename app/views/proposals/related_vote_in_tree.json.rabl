if @vote
  object @vote

  attributes :id, :comment, :created_at

  child :proposal do
    attributes :id, :statement

    child :hub do
      attributes :id, :group_name, :formatted_location
    end
  end
end