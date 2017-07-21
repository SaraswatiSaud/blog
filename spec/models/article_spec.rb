require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @article = FactoryGirl.build(:article, user_id: @user.id)
  end

  it 'has a valid factory' do
    expect(@article).to be_valid
  end

  it 'is valid with title, text, user_id' do
    expect(@article).to be_valid
  end

  it 'is invalid without title' do
    @article.title = nil
    @article.valid?
    expect(@article.errors[:title]).to include("can't be blank")
  end

  it 'title is valid if 5 or more characters long' do
    @article.title = 'More than 5'
    expect(@article).to be_valid
  end

  it 'title is invalid if less than 5 characters long' do
    @article.title = 'four'
    expect(@article).to_not be_valid
  end

  it 'title is unique per user' do
    # same user with same title
    @article.save
    article2 = Article.new(title: @article.title, text: @article.text, user_id: @user.id)
    article2.valid?
    expect(article2.errors[:title]).to include('has already been taken')
  end

  it 'title is same for different user' do
    # different user with same title
    @article.save
    @article2 = FactoryGirl.build(:article, title: @article.title)
    user2 = FactoryGirl.create(:user)
    @article2.user_id = user2.id
    expect(@article2).to be_valid
  end

  it 'is invalid without text' do
    @article.text = nil
    expect(@article).to_not be_valid
  end

  it 'is invalid without user_id' do
    @article.user_id = nil
    expect(@article).to_not be_valid
  end

  it 'belongs to a user' do
    expect(@article.user).to eq @user
  end

  it 'has many comments' do
    @user.save
    article = FactoryGirl.create(:article, user_id: @user.id)
    c1 = FactoryGirl.create(:comment, article: article)
    c2 = FactoryGirl.create(:comment, article: article)

    c3 = FactoryGirl.create(:comment, article: FactoryGirl.create(:article, user_id: @user.id))

    expect(article.comments).to include(c1, c2)
    expect(article.comments).to_not include(c3)
  end

  it 'destroys comments if deleted' do
    @article.save
    c1 = FactoryGirl.create(:comment, article_id: @article.id)

    expect(@article.comments).to include(c1)
    @article.destroy
    expect(@article.comments).to_not include(c1)
  end
end
