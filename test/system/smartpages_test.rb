require "application_system_test_case"

class SmartpagesTest < ApplicationSystemTestCase
  setup do
    @smartpage = smartpages(:one)
  end

  test "visiting the index" do
    visit smartpages_url
    assert_selector "h1", text: "Smartpages"
  end

  test "creating a Smartpage" do
    visit smartpages_url
    click_on "New Smartpage"

    fill_in "Path", with: @smartpage.path
    fill_in "Shop", with: @smartpage.shop_id
    click_on "Create Smartpage"

    assert_text "Smartpage was successfully created"
    click_on "Back"
  end

  test "updating a Smartpage" do
    visit smartpages_url
    click_on "Edit", match: :first

    fill_in "Path", with: @smartpage.path
    fill_in "Shop", with: @smartpage.shop_id
    click_on "Update Smartpage"

    assert_text "Smartpage was successfully updated"
    click_on "Back"
  end

  test "destroying a Smartpage" do
    visit smartpages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Smartpage was successfully destroyed"
  end
end
