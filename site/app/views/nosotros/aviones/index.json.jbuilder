json.array!(@nosotros_aviones) do |nosotros_avione|
  json.extract! nosotros_avione, :id
  json.url nosotros_avione_url(nosotros_avione, format: :json)
end
