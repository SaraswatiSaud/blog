require 'rails_helper'

RSpec.feature "Articles", type: :feature do
  scenario 'user Login into a page' do
    user = FactoryGirl.create(:user)

    visit root_path
    click_link "Login"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect {
      click_link 'New Article'
      fill_in 'Title', with: 'Test Article'
      fill_in 'Text', with: 'This is test article'
      click_button 'Create Article'
    }.to change(user.articles, :count).by(1)
    expect(page).to have_content 'Test Article'
  end


end
