json.array!(@api_aviones) do |api_avione|
  json.extract! api_avione, :id
  json.url api_avione_url(api_avione, format: :json)
end
