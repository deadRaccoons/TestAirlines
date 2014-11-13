json.array!(@tarjeta) do |tarjetum|
  json.extract! tarjetum, :id
  json.url tarjetum_url(tarjetum, format: :json)
end
