class AttachementSerializer < ActiveModel::Serializer
  attributes :name, :url

  def url
    object.file.url
  end
end
