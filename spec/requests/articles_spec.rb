require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  context 'as an authenticated user' do
    before do
      @user = FactoryGirl.create(:user)
    end

    context 'with valid attributes' do
      it 'adds an article' do
        article_params = FactoryGirl.attributes_for(:article)
        sign_in @user
        expect {
          post articles_path, params: { article: article_params }
        }.to change(@user.articles, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'doesnot add an attributes' do
        article_params = FactoryGirl.attributes_for(:article, :invalid)
        sign_in @user
        expect {
          post articles_path, params: { article: article_params }
        }.to_not change(@user.articles, :count)
      end
    end
  end
end
