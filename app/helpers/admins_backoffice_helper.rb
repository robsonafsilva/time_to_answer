module AdminsBackofficeHelper
  def translate_attribute(object = nil, method = nil)
  if object && method    
      object.human_attribute_name(method)
  else
    "Informe os parametros corretamente"
  end
end
end
