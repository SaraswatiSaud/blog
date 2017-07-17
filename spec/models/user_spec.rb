require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  it 'has a valid factory' do
    expect(@user).to be_valid
  end

  it 'is valid with email and password' do
    expect(@user).to be_valid
  end

  it 'is invalid without email' do
    @user.email = nil
    @user.valid?
    expect(@user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without password' do
    @user.password = nil
    @user.valid?
    expect(@user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    @user.save
    user = FactoryGirl.build(:user, email: @user.email)
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it 'has many articles' do
    @user.save
    a1 = FactoryGirl.create(:article, user_id: @user.id)
    a2 = FactoryGirl.create(:article, user_id: @user.id)

    expect(a1.user.articles).to include(a1, a2)
  end

  it 'destroys articles if deleted' do
    @user.save
    c1 = FactoryGirl.create(:article, user_id: @user.id)

    expect(c1.user.articles).to include(c1)
    c1.user.destroy
    expect(c1.user.articles).to_not include(c1)
  end
end
