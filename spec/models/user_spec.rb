require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it 'is valid with email and password' do
    user = FactoryGirl.build(:user, email: 'admin@example.com', password: 'password')
    expect(user).to be_valid
  end

  it 'is invalid without email' do
    user = FactoryGirl.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without password' do
    user = FactoryGirl.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    FactoryGirl.create(:user, email: "admin@example.com")
    user = FactoryGirl.build(:user, email: "admin@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it 'has many articles' do
    user = User.create(email: 'admin@example.com', password: 'password')
    a1 = Article.create(title: 'Article 1', text: 'article1', user_id: user.id)
    a2 = Article.create(title: 'Article 2', text: 'article2', user_id: user.id)
    expect(user.articles).to include(a1, a2)
  end

  it 'destroys articles if deleted' do
    user = User.create(email: 'admin@example.com', password: 'password')
    c1 = Article.create(title: 'Article 1', text: 'article1', user_id: user.id)

    expect(user.articles).to include(c1)
    user.destroy
    expect(user.articles).to_not include(c1)
  end
end
