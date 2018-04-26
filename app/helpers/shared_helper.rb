module SharedHelper
  def attachement_class(form)
    klass = form.object.attachable.class.to_s.downcase
    "#{klass}_attachement"
  end
end
