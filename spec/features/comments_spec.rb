require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  before(:each) do
    @user = FactoryGirl.create(:user)
    visit root_path

    click_link 'Login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'

    visit articles_path
    @article = FactoryGirl.create(:article, user: @user)

    click_link 'New Article'
    fill_in 'Title', with: 'Test Article'
    fill_in 'Text', with: @article.text
    click_button 'Create Article'
  end

  scenario 'created by user and deleted' do
    fill_in 'Commenter', with: 'Pintoo'
    fill_in 'Body', with: 'This is comment'
    click_button 'Create Comment'

    expect(page).to have_content 'Pintoo'
    expect(page).to have_content 'This is comment'
  end
end
