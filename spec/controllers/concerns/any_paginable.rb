require 'rails_helper'
require 'with_model'

class AnyPaginatedController < ApplicationController; end

RSpec.describe AnyPaginatedController, type: :controller do
  controller AnyPaginatedController do
    skip_authorization_check
    include Paginated

    def index
      head :ok
    end
  end

  with_model :any_paginable do
    table do |t|
      t.string :text, default: ''
    end

    model do; end
  end

  let!(:any_paginables) do
    30.times.map { |x| AnyPaginable.new(text: "AnyText " << x) }
  end

  describe 'GET #index' do
    context 'page' do
      it 'assigns default page number' do
        get :index
        expect(assigns(:page)).to eq(1)
      end

      it 'assigns page number' do
        get :index, params: { page: 2 }
        expect(assigns(:page)).to eq('2')
      end 
    end

    context 'per_page' do
      it 'assigns default per_page number' do
        get :index
        expect(assigns(:per_page)).to eq(20)
      end

      it 'assigns per_page number' do
        get :index, params: { per_page: 30 }
        expect(assigns(:per_page)).to eq('30')
      end
    end
  end
end
