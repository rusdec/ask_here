module Polymorphed
  extend ActiveSupport::Concern

  included do
    def set_resource
      param = resource_param
      return nil if params[param].nil?
      instance_variable_set '@resource', resource_klass(param).find(params[param])
    end

    private

    def resource_param
      params.each { |param, _| return param if /_id$/.match(param) }
    end

    def resource_klass(param)
      param.split('_')[0].classify.constantize
    end
  end
end
