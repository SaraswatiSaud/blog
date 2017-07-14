require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.create(email: 'test@example.com', password: '123456789')
  end

  it 'is valid with email and password' do
    expect(@user).to be_valid
  end

  it 'is invalid without email' do
    @user.email = nil
    expect(@user).to_not be_valid
  end

  it 'is invalid without password' do
    @user.password = nil
    expect(@user).to_not be_valid
  end

  it 'is invalid with a duplicate email address' do
    user = User.new(email: 'test@example.com', password: '123456789')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end
end
