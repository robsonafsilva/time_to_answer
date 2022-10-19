class Site::SearchController < SiteController
  def questions
   # params[:term]
   # @questions = Question.all
   # as entrada lower e LIKE são comandos sql
   @questions = Question.includes(:answers)
                .where("lower(description) LIKE ?", "%#{params[:term].downcase}%")
                .page(params[:page])
  end
end
