class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :check_pagination

  protected
  def layout_by_resource
    # ser for um devise_controller
    # pega a saida do resouce_class converte para string tranforma em minúsculo e chama o layou com o nome resultante
    # senão chama o application layout (views/layout/aplication.html.erb)
     devise_controller? ? "#{resource_class.to_s.downcase}_devise" : "application"
  end

  def check_pagination
    unless user_signed_in?
      params.extract!(:page)
    end
  end
  
end
