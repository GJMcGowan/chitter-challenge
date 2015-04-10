require 'spec_helper'

feature 'User can sign up' do
  scenario 'when they are new to the site' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Hello George,')
  end

  scenario 'there is a list of all users' do
    sign_up
    sign_up('Ryan', 'me@ryan.com', 'bat')
    visit '/users/all'
    expect(page).to have_content('cat')
    expect(page).to have_content('bat')
  end

  scenario 'once signed up, their username is displayed on every page' do
    sign_up
    visit '/'
    expect(page).to have_content 'cat'
  end

  # This could be done better using flash or something, but fine for now
  scenario 'error will be raised when their email is already registered' do
    sign_up
    sign_up
    expect(page).to have_content('That email is already taken')
  end

  def sign_up(name = 'George', email = 'me@georgemcgowan.com',
              username = 'cat', password = '12345')
    visit '/'
    fill_in('Name', with: name)
    fill_in('Email', with: email)
    fill_in('Username', with: username)
    fill_in('Password', with: password)
    click_button('Submit')
  end
end

feature 'User can log out' do
  xscenario 'user signs up and then logs out' do
    sign_up
    visit '/'
    click_button('Log Out')
    expect(page).not_to have_content('cat')
  end

  # test for someone who didn't log in being able to see sign out.
end

feature 'User can log in' do

  xscenario 'user logs in with correct details' do
    log_in
    expect(page).to have_content('cat')
  end

  xscenario 'error someone logs in with the wrong details' do
  end

  def log_in(username = 'cat', password = '12345')
    visit '/'
    fill_in('Login_username', with: username)
    fill_in('Login_password', with: password)
    click_button('Submit')
  end

end
