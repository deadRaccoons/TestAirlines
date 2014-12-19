json.array!(@promociones) do |promocione|
  json.extract! promocione, :id
  json.url promocione_url(promocione, format: :json)
end
