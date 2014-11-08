json.array!(@avions) do |avion|
  json.extract! avion, :id, :idavion, :modelo, :marca, :capacidadprimera, :capacidadturista, :disponible
  json.url avion_url(avion, format: :json)
end
