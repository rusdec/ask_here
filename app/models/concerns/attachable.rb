module Attachable
  extend ActiveSupport::Concern
  included do
    has_many :attachements, as: :attachable,
                            inverse_of: :attachable,
                            dependent: :destroy

    accepts_nested_attributes_for :attachements, allow_destroy: true,
                                                 reject_if: :all_blank
  end
end 
