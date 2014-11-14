json.array!(@usuarios) do |usuario|
  json.extract! usuario, :id
  json.url usuario_url(usuario, format: :json)
end
