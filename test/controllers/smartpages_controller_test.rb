require 'test_helper'

class SmartpagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @smartpage = smartpages(:one)
  end

  test "should get index" do
    get smartpages_url
    assert_response :success
  end

  test "should get new" do
    get new_smartpage_url
    assert_response :success
  end

  test "should create smartpage" do
    assert_difference('Smartpage.count') do
      post smartpages_url, params: { smartpage: { path: @smartpage.path, shop_id: @smartpage.shop_id } }
    end

    assert_redirected_to smartpage_url(Smartpage.last)
  end

  test "should show smartpage" do
    get smartpage_url(@smartpage)
    assert_response :success
  end

  test "should get edit" do
    get edit_smartpage_url(@smartpage)
    assert_response :success
  end

  test "should update smartpage" do
    patch smartpage_url(@smartpage), params: { smartpage: { path: @smartpage.path, shop_id: @smartpage.shop_id } }
    assert_redirected_to smartpage_url(@smartpage)
  end

  test "should destroy smartpage" do
    assert_difference('Smartpage.count', -1) do
      delete smartpage_url(@smartpage)
    end

    assert_redirected_to smartpages_url
  end
end
