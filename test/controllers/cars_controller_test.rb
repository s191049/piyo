require 'test_helper'

class CarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @car = Car.new(division:1, oil_type:1, number:1)
  end

  test 'should get new' do
    get cars_new_url
    assert_response :success
  end

  test 'should post confirm' do
    post cars_confirm_url, params: { car: @car.attributes }
    assert_response :success
  end

  test 'should get create' do
    get cars_create_url
    assert_response :success
  end

  test 'should get show' do
    get cars_show_url
    assert_response :success
  end

  test 'should get edit' do
    get cars_edit_url
    assert_response :success
  end

  test 'should get update' do
    get cars_update_url
    assert_response :success
  end

  test 'should get destroy' do
    get cars_destroy_url
    assert_response :success
  end

  test 'should get search' do
    get cars_search_url
    assert_response :success
  end

  test 'should get import' do
    get cars_import_url
    assert_response :success
  end

  test 'should get export' do
    get cars_export_url
    assert_response :success
  end
end
