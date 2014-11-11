json.array!(@promocions) do |promocion|
  json.extract! promocion, :id, :idpromocion, :codigoPromocion, :porcentaje, :fechaentrada, :vigencia
  json.url promocion_url(promocion, format: :json)
end
