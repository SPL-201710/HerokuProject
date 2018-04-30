require 'test_helper'

class VocessLocutorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vocess_locutor = vocess_locutors(:one)
  end

  test "should get index" do
    get vocess_locutors_url
    assert_response :success
  end

  test "should get new" do
    get new_vocess_locutor_url
    assert_response :success
  end

  test "should create vocess_locutor" do
    assert_difference('VocessLocutor.count') do
      post vocess_locutors_url, params: { vocess_locutor: { apellidosLocutor: @vocess_locutor.apellidosLocutor, comentarios: @vocess_locutor.comentarios, concurso_id: @vocess_locutor.concurso_id, convertidaURL: @vocess_locutor.convertidaURL, emailLocutor: @vocess_locutor.emailLocutor, estado: @vocess_locutor.estado, nombresLocutor: @vocess_locutor.nombresLocutor, originalURL: @vocess_locutor.originalURL } }
    end

    assert_redirected_to vocess_locutor_url(VocessLocutor.last)
  end

  test "should show vocess_locutor" do
    get vocess_locutor_url(@vocess_locutor)
    assert_response :success
  end

  test "should get edit" do
    get edit_vocess_locutor_url(@vocess_locutor)
    assert_response :success
  end

  test "should update vocess_locutor" do
    patch vocess_locutor_url(@vocess_locutor), params: { vocess_locutor: { apellidosLocutor: @vocess_locutor.apellidosLocutor, comentarios: @vocess_locutor.comentarios, concurso_id: @vocess_locutor.concurso_id, convertidaURL: @vocess_locutor.convertidaURL, emailLocutor: @vocess_locutor.emailLocutor, estado: @vocess_locutor.estado, nombresLocutor: @vocess_locutor.nombresLocutor, originalURL: @vocess_locutor.originalURL } }
    assert_redirected_to vocess_locutor_url(@vocess_locutor)
  end

  test "should destroy vocess_locutor" do
    assert_difference('VocessLocutor.count', -1) do
      delete vocess_locutor_url(@vocess_locutor)
    end

    assert_redirected_to vocess_locutors_url
  end
end
