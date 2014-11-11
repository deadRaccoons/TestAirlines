json.array!(@usuarios) do |usuario|
  json.extract! usuario, :id, :correo, :idusuario, :nombres, :apellidopaterno, :apellidomaterno, :nacionalidad, :genero, :fechanacimiento, :url_imagen
  json.url usuario_url(usuario, format: :json)
end
