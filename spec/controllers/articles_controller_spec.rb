require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe '#index' do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it 'responds successfully' do
      get :index
      expect(response).to be_success
    end

    it 'returns a 200 response' do
      get :index
      expect(response).to have_http_status '200'
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      before do
        @user = FactoryGirl.create(:user)
        @article = FactoryGirl.create(:article, user_id: @user.id)
        sign_in @user
      end

      it 'responds successfully' do
        get :show, params: { id: @article.id }
        expect(response).to be_success
      end
    end
  end
end
