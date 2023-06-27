class SearchController < ApplicationController
  skip_authorization_check only: [:index]

  def index
    @type = params[:type]
    @query = params[:q]

    if @type == 'user'
      # Realiza la búsqueda de personas
      if @query.blank?
        @results = User.all
      else
        @results = User.where("name LIKE ?", "%#{@query}%")
      end
    elsif @type == 'presentation'
      # Realiza la búsqueda de archivos
      if @query.blank?
        @results = Presentation.all
      else
        @results = Presentation.where("title LIKE ?", "%#{@query}%")
      end
    else
      # Categoría no válida
      @results = Presentation.where("title LIKE ?", "%#{@query}%")
      @results2 = User.where("name LIKE ?", "%#{@query}%")
    end

    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: 'results'
        end
      end
    end
  end

  def advanced
    respond_to do |format|
      format.html do
        render
      end
    end
  end
end
