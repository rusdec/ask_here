module JsonResponsed
  extend ActiveSupport::Concern

  included do
    private

    def json_response_by_result(params = {}, resource = nil)
      resource ||= json_responsible_resource
      resource.errors.any? ? json_response_error(resource.errors.full_messages)
                           : json_response_success('Success', params)
    end

    def json_response_success(message = '', params = {})
      render json: { status: true, message: message }.merge(params)
    end

    def json_response_error(errors = [], params = {})
      render json: { status: false, errors: errors }.merge(params)
    end

    def json_response_you_can_not_do_it
      json_response_error(['You can not do it'])
    end

    def json_responsible_resource
      instance_variable_get("@#{resource_name}")
    end

    def resource_name
      controller_name.underscore.singularize
    end
  end
end
