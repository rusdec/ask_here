module JsonResponsed
  extend ActiveSupport::Concern

  included do
    private

    def json_response_by_result(result, resource, params = {})
      result ? json_response_success('Success', params)
             : json_response_error(resource.errors.full_messages)
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
  end
end
