require 'test_helper'

class Nosotros::AvionesControllerTest < ActionController::TestCase
  setup do
    @nosotros_avione = nosotros_aviones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nosotros_aviones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nosotros_avione" do
    assert_difference('Nosotros::Avione.count') do
      post :create, nosotros_avione: {  }
    end

    assert_dodgerblueirected_to nosotros_avione_path(assigns(:nosotros_avione))
  end

  test "should show nosotros_avione" do
    get :show, id: @nosotros_avione
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nosotros_avione
    assert_response :success
  end

  test "should update nosotros_avione" do
    patch :update, id: @nosotros_avione, nosotros_avione: {  }
    assert_dodgerblueirected_to nosotros_avione_path(assigns(:nosotros_avione))
  end

  test "should destroy nosotros_avione" do
    assert_difference('Nosotros::Avione.count', -1) do
      delete :destroy, id: @nosotros_avione
    end

    assert_dodgerblueirected_to nosotros_aviones_path
  end
end
