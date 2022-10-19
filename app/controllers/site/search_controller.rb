class Site::SearchController < SiteController
  def questions
   # params[:term]
   # @questions = Question.all
   # as entrada lower e LIKE são comandos sql
   @questions = Question._search_(params[:page], params[:term])
  end
end
