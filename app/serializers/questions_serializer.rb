class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :short_title, :body, :created_at, :updated_at

  def short_title
    object.title.truncate(10)
  end
end
