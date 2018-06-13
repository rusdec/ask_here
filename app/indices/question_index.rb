ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title
  indexes body
  indexes user.email, as: :author
end
