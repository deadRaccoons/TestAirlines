require 'test_helper'

class PromocionesControllerTest < ActionController::TestCase
  setup do
    @promocione = promociones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:promociones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create promocione" do
    assert_difference('Promocione.count') do
      post :create, promocione: {  }
    end

    assert_redirected_to promocione_path(assigns(:promocione))
  end

  test "should show promocione" do
    get :show, id: @promocione
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @promocione
    assert_response :success
  end

  test "should update promocione" do
    patch :update, id: @promocione, promocione: {  }
    assert_redirected_to promocione_path(assigns(:promocione))
  end

  test "should destroy promocione" do
    assert_difference('Promocione.count', -1) do
      delete :destroy, id: @promocione
    end

    assert_redirected_to promociones_path
  end
end
