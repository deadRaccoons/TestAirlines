json.array!(@ciudades) do |ciudade|
  json.extract! ciudade, :id
  json.url ciudade_url(ciudade, format: :json)
end
