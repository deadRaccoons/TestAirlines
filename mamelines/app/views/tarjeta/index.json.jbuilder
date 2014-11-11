json.array!(@tarjeta) do |tarjetum|
  json.extract! tarjetum, :id, :notarjeta, :idusuario, :valor, :saldo, :saldo
  json.url tarjetum_url(tarjetum, format: :json)
end
