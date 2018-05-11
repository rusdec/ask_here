require 'rails_helper'
require 'with_model'

class AnyJsonResponsedsController < ApplicationController; end

RSpec.describe AnyJsonResponsedsController, type: :controller do
  controller do
    include JsonResponsed

    def success
      if params[:params]
        json_response_by_result(true, OpenStruct.new, { param: params[:params] })
      else
        json_response_by_result(true, OpenStruct.new)
      end
    end

    def error
      resource = OpenStruct.new(errors: OpenStruct.new(full_messages: ['Any error']))
      json_response_by_result(false, resource)
    end

    def you_can_not_do_it
      json_response_you_can_not_do_it
    end
  end
  
  before do
    routes.draw do
      [:success, :error, :you_can_not_do_it].each do |method|
        get method, to: "any_json_responseds##{method}"
      end
    end
  end

  describe 'GET #error' do
    it 'respond with error' do
      get :error, format: :json

      expect(response.body).to match('{"status":false,"errors":["Any error"]}')
    end
  end

  describe 'GET #success' do
    it 'respond with success' do
      get :success, format: :json

      expect(response.body).to match('{"status":true,"message":"Success"}')
    end
    context 'when params is given' do
      it 'respond with success and params' do
        get :success, params: { params: 'Any param' }, format: :json

       expect(response.body).to match('{"status":true,"message":"Success","param":"Any param"}')
      end
    end
  end

  describe 'GET #you_can_not_do_it' do
    it 'respond with error' do
      get :you_can_not_do_it, format: :json

      expect(response.body).to match('{"status":false,"errors":["You can not do it"]}')
    end
  end
end