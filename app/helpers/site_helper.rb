module SiteHelper
  def msg_jumbotron
    case params[:action]
    when 'index'
      "últimas perguntas cadastradas..."
    when 'questions'
      "Resultado para o termo #{params[:term]}"
    when 'subject'
      "Questões da categoria: \"#{params[:subject]}\""
    end
  end
end

