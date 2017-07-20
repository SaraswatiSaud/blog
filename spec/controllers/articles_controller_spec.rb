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

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = FactoryGirl.create(:user)
      end

      it 'adds a new article' do
        article_params = FactoryGirl.attributes_for(:article)
        sign_in @user
        expect {
          post :create, params: { article: article_params }
        }.to change(@user.articles, :count).by(1)
      end
    end

    context 'as a guest user' do
      it 'returns a 302 response' do
        article_params = FactoryGirl.attributes_for(:article)
        post :create, params: { article: article_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        article_params = FactoryGirl.attributes_for(:article)
        post :create, params: { article: article_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as a guest' do
      before do
        @user = FactoryGirl.create(:user)
        @article = FactoryGirl.create(:article)
      end

      it 'returns a 302 response' do
        article_params = FactoryGirl.attributes_for(:article)
        patch :update, params: { id: @article.id, article: article_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        article_params = FactoryGirl.attributes_for(:article)
        patch :update, params: { id: @article.id, article: article_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryGirl.create(:user)
        other_user = FactoryGirl.create(:user)
        @article = FactoryGirl.create(:article, user_id: other_user.id, title: "Same Old title")
      end

      it 'does not update the article' do
        article_params = FactoryGirl.attributes_for(:article, title: "New title")
        sign_in @user
        patch :update, params: { id: @article.id, article: article_params }
        expect(@article.reload.title).to eq "Same Old title"
      end

      it 'redirects to the dashboard' do
        article_params = FactoryGirl.attributes_for(:article)
        sign_in @user
        patch :update, params: { id: @article.id, article: article_params }
        expect(response).to redirect_to articles_path
      end
    end

    context 'as an authorized user' do
      before do
        @user = FactoryGirl.create(:user)
        @article = FactoryGirl.create(:article, user_id: @user.id)
      end

      it 'updates a article' do
        article_params = FactoryGirl.attributes_for(:article, title: "New article Name")
        sign_in @user
        patch :update, params: { id: @article.id, article: article_params }
        expect(@article.reload.title).to eq "New article Name"
      end
    end
  end
end
