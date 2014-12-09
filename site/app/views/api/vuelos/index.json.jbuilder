json.array!(@api_vuelos) do |api_vuelo|
  json.extract! api_vuelo, :id
  json.url api_vuelo_url(api_vuelo, format: :json)
end
