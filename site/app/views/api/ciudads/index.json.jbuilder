json.array!(@api_ciudads) do |api_ciudad|
  json.extract! api_ciudad, :id
  json.url api_ciudad_url(api_ciudad, format: :json)
end
