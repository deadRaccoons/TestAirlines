json.array!(@vuelos) do |vuelo|
  json.extract! vuelo, :id
  json.url vuelo_url(vuelo, format: :json)
end
