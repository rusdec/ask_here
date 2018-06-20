class Attachement < ApplicationRecord
  belongs_to :attachable, polymorphic: true, touch: true
  mount_uploader :file, FileUploader

  before_save do
    self.name = file.identifier
  end
end
