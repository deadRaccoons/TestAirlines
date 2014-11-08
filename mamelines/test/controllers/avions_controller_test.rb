require 'test_helper'

class AvionsControllerTest < ActionController::TestCase
  setup do
    @avion = avions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:avions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create avion" do
    assert_difference('Avion.count') do
      post :create, avion: { capacidadprimera: @avion.capacidadprimera, capacidadturista: @avion.capacidadturista, disponible: @avion.disponible, idavion: @avion.idavion, marca: @avion.marca, modelo: @avion.modelo }
    end

    assert_redirected_to avion_path(assigns(:avion))
  end

  test "should show avion" do
    get :show, id: @avion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @avion
    assert_response :success
  end

  test "should update avion" do
    patch :update, id: @avion, avion: { capacidadprimera: @avion.capacidadprimera, capacidadturista: @avion.capacidadturista, disponible: @avion.disponible, idavion: @avion.idavion, marca: @avion.marca, modelo: @avion.modelo }
    assert_redirected_to avion_path(assigns(:avion))
  end

  test "should destroy avion" do
    assert_difference('Avion.count', -1) do
      delete :destroy, id: @avion
    end

    assert_redirected_to avions_path
  end
end
