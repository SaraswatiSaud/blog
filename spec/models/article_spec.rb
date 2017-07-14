require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @user = User.create(email: 'test@example.com', password: '12345678')
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

  # it 'has many comments'
  # it 'destroys comments if deleted'
end