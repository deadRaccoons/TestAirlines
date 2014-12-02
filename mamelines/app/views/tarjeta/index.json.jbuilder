json.array!(@tarjeta) do |tarjetum|
  json.extract! tarjetum, :id, :notarjeta, :valor, :idusuario, :disponible
  json.url tarjetum_url(tarjetum, format: :json)
end
