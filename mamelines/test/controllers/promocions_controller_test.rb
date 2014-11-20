require 'test_helper'

class PromocionsControllerTest < ActionController::TestCase
  setup do
    @promocion = promocions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:promocions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create promocion" do
    assert_difference('Promocion.count') do
      post :create, promocion: { fechaentrada: @promocion.fechaentrada, idpromocion: @promocion.idpromocion, porcentaje: @promocion.porcentaje, vigencia: @promocion.vigencia }
    end

    assert_redirected_to promocion_path(assigns(:promocion))
  end

  test "should show promocion" do
    get :show, id: @promocion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @promocion
    assert_response :success
  end

  test "should update promocion" do
    patch :update, id: @promocion, promocion: { fechaentrada: @promocion.fechaentrada, idpromocion: @promocion.idpromocion, porcentaje: @promocion.porcentaje, vigencia: @promocion.vigencia }
    assert_redirected_to promocion_path(assigns(:promocion))
  end

  test "should destroy promocion" do
    assert_difference('Promocion.count', -1) do
      delete :destroy, id: @promocion
    end

    assert_redirected_to promocions_path
  end
end
