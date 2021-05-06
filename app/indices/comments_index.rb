ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body, sortable: true

  has  created_at, updated_at, commentable_type, commentable_id
end
