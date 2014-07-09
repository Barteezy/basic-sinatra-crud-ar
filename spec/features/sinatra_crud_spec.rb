require "spec_helper"

feature "User Authentication" do
  scenario "user can register and login" do
    visit "/"
    click_on "Registration"
  end
end