require "spec_helper"

feature "Fish App" do
  scenario "User Authentication" do
    visit "/"
    click_on "Register"


    expect(page).to have_content "Register For Fish.lyp"

    fill_in "username", :with => "bob"
    fill_in "password", :with => "bob"

    click_on "Register"

    visit "/"

    expect(page).to have_content "Or"

    fill_in "username", :with => "bob"
    fill_in "password", :with => "bob"

    click_on "Login"


    expect(page).to have_content "Welcome bob"

    visit "/"


    fill_in "username", :with => "bob"
    fill_in "password", :with => "bob"

    click_on "Login"

    expect(page).to have_content "Welcome bob"

    expect(page).to have_content "Here are the fish you've uploaded"


  end
end