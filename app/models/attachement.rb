class Attachement < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  mount_uploader :file, FileUploader
end
