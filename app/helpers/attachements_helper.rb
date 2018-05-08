module AttachementsHelper
  def extract_attachement_name(form_element)
    form_element.object.name
  end
end
