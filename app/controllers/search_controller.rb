class SearchController < ApplicationController
  skip_authorization_check only: [:index]

  def index
    @type = params[:type]
    @query = params[:q]
    @tags = params[:tags]
    @tags_array = []
    @sort_by = params[:sort_by]
    
    Presentation.all.each do |presentation|
      @tags_array.concat(presentation.tag_list)
    end

    if @type == 'user'
      # Realiza la búsqueda de personas
      if @query.blank?
        @results = User.all
      else
        @results = User.where("name ILIKE  ?", "%#{@query}%")
      end
    elsif @type == 'presentation'
      # Realiza la búsqueda de archivos
      if @query.blank?
        if @tags.blank?
          @results = Presentation.all
        else
          @results = Presentation.tagged_with(@tags, any: true) 
        end
      else
        if @tags.blank?
          @results = Presentation.where("title ILIKE  ?", "%#{@query}%")
        else
          @results = Presentation.where("title ILIKE  ?", "%#{@query}%").tagged_with(@tags, any: true)
        end
      end
    else
      # Categoría no válida
      @results = Presentation.where("title ILIKE  ?", "%#{@query}%")
      @results2 = User.where("name ILIKE  ?", "%#{@query}%")
    end

    if @sort_by.present?
      if @sort_by == 'recent_date'
        @results = @results.order(created_at: :desc)
      elsif @sort_by == 'oldest_date'
        @results = @results.order(created_at: :asc)
      end
    end


    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: 'results'
        end
      end
    end
  end
end
