require 'test_helper'

class VuelosControllerTest < ActionController::TestCase
  setup do
    @vuelo = vuelos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vuelos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vuelo" do
    assert_difference('Vuelo.count') do
      post :create, vuelo: {  }
    end

    assert_redirected_to vuelo_path(assigns(:vuelo))
  end

  test "should show vuelo" do
    get :show, id: @vuelo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vuelo
    assert_response :success
  end

  test "should update vuelo" do
    patch :update, id: @vuelo, vuelo: {  }
    assert_redirected_to vuelo_path(assigns(:vuelo))
  end

  test "should destroy vuelo" do
    assert_difference('Vuelo.count', -1) do
      delete :destroy, id: @vuelo
    end

    assert_redirected_to vuelos_path
  end
end
