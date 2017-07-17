require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @user = User.create(email: 'test@example.com', password: '123456789')
    @article = Article.new(title: 'Abcdef', text: 'Hello', user_id: @user.id)
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
    @article2 = Article.new(title: @article.title, text: 'Hi555555', user_id: @user.id)
    expect(@article2).to_not be_valid

    # different user with same title
    user2 = User.create(email: 'test1@example.com', password: '12345678')
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

    c3 = FactoryGirl.create(:comment, article: FactoryGirl.create(:article))

    expect(article.comments).to include(c1, c2)
    expect(article.comments).to_not include(c3)
  end

  it 'destroys comments if deleted' do
    @article.save
    c1 = Comment.create(commenter: 'Ram', body: 'Testing123', article_id: @article.id)

    expect(@article.comments).to include(c1)
    @article.destroy
    expect(@article.comments).to_not include(c1)
  end
end
