require 'test_helper'

class CiudadesControllerTest < ActionController::TestCase
  setup do
    @ciudade = ciudades(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ciudades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ciudade" do
    assert_difference('Ciudade.count') do
      post :create, ciudade: {  }
    end

    assert_redirected_to ciudade_path(assigns(:ciudade))
  end

  test "should show ciudade" do
    get :show, id: @ciudade
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ciudade
    assert_response :success
  end

  test "should update ciudade" do
    patch :update, id: @ciudade, ciudade: {  }
    assert_redirected_to ciudade_path(assigns(:ciudade))
  end

  test "should destroy ciudade" do
    assert_difference('Ciudade.count', -1) do
      delete :destroy, id: @ciudade
    end

    assert_redirected_to ciudades_path
  end
end
