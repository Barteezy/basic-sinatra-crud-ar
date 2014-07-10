require "spec_helper"

feature "User Authentication" do
  scenario "user can register and login" do
    visit "/"
    click_on "Register"
    visit "/register"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"

    fill_in "Username", :with => "todd"
    fill_in "Password", :with => "todd"

    click_on "Sign Up"

    expect(page).to have_content "Thank you for registering"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"


    fill_in "Username", :with => "todd"
    fill_in "Password", :with => "todd"

    click_on "Login"

    click_on "Logout"

  end
  scenario "check validations" do
    visit "/"
    click_on "Register"

    fill_in "Username", :with => ""

    click_on "Sign Up"

    expect(page).to have_content "Username cannot be blank"
  end

  scenario "As a logged in user" do
    visit "/"
    click_on "Register"
    visit "/register"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"

    fill_in "Username", :with => "todd"
    fill_in "Password", :with => "todd"

    click_on "Sign Up"

    expect(page).to have_content "Thank you for registering"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"


    fill_in "Username", :with => "todd"
    fill_in "Password", :with => "todd"

    click_on "Login"

    expect(page).to have_content "Users"
    expect(page).to have_content "bob"

    click_on "Sort"

    expect(page).to have_content "Sorted Users"
  end
  scenario "as logged in user " do
    visit "/"
    click_on "Register"
    visit "/register"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"

    fill_in "Username", :with => "todd"
    fill_in "Password", :with => "todd"

    click_on "Sign Up"

    expect(page).to have_content "Thank you for registering"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"


    fill_in "Username", :with => "todd"
    fill_in "Password", :with => "todd"

    click_on "Login"

    fill_in "username", :with => "kim"

    click_on "Delete"

    expect(page).to_not have_content "kim"
  end


end
