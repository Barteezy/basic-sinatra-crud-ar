require "spec_helper"

feature "Fish App" do
  scenario "User Authentication" do
    visit "/"
    click_on "Register"

    expect(page).to have_content "Register For The Fish App"

    fill_in "username", :with => "bob"
    fill_in "password", :with => "bob"

    click_on "Register"

    expect(page).to have_content "Login"

    fill_in "username", :with => "bob"
    fill_in "password", :with => "bob"

    click_on "Login"

    expect(page).to have_content "Welcome bob"

    click_on "logout"

    expect(page).to have_content "Register"


  end
end