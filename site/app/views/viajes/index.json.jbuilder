json.array!(@viajes) do |viaje|
  json.extract! viaje, :id
  json.url viaje_url(viaje, format: :json)
end
