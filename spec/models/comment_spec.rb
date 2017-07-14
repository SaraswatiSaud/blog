require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @user = User.create(email: 'test@example.com', password: '12345678')
    @article = Article.create(title: 'Abcdef', text: 'Hello', user_id: @user.id)
    @comment = Comment.new(commenter: 'Pintoo', body: 'This article is awesome.', article_id: @article.id)
  end

  it 'is valid with commenter, body, article_id' do
    expect(@comment).to be_valid
  end

  it 'is invalid without commenter' do
    @comment.commenter = nil
    @comment.valid?
    expect(@comment.errors[:commenter]).to include("can't be blank")
  end

  it 'is invalid without body' do
    @comment.body = nil
    expect(@comment).to_not be_valid
  end

  it 'must be atleast 5 characters long' do
    @comment.body = 'Atleat 5 characters long'
    expect(@comment).to be_valid
  end

  it 'is invalid if less than 5 characters long' do
    @comment.body = 'four'
    expect(@comment).to_not be_valid
  end

  it 'is invalid without article_id' do
    @comment.article_id = nil
    expect(@comment).to_not be_valid
  end

  it 'belongs to article' do
    expect(@comment.article).to eq @article
  end

end
