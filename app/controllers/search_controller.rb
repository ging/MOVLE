class SearchController < ApplicationController
  skip_authorization_check only: [:index]

  def index
    @type = params[:type]
    @query = params[:q]
    @tags = params[:tags]
    @tags_array = []
    @sort_by = params[:sort_by]

    @combined_results = []
    @links = Link.all + Embed.all
    
    Presentation.all.each do |presentation|
      @tags_array.concat(presentation.tag_list)
    end

    case @type
    when 'user'
      # Realiza la búsqueda de personas
      @results = @query.blank? ? User.all : User.where("name ILIKE ?", "%#{@query}%")
    when 'link'
      # Realiza la búsqueda de links
      @results = @query.blank? ? @links : @links.where("title ILIKE ?", "%#{@query}%")
    when 'presentation'
      # Realiza la búsqueda de archivos
      @results = if @query.blank?
                    @tags.blank? ? Presentation.all : Presentation.tagged_with(@tags, any: true)
                  else
                    @tags.blank? ? Presentation.where("title ILIKE ?", "%#{@query}%") : Presentation.where("title ILIKE ?", "%#{@query}%").tagged_with(@tags, any: true)
                  end
    else
      # Combinar resultados de usuarios y presentaciones
      @results = Presentation.where("title ILIKE ?", "%#{@query}%")
      @results_users = User.where("name ILIKE ?", "%#{@query}%")
      @link_results = Link.where("title ILIKE ?", "%#{@query}%")
      @embed_results = Embed.where("title ILIKE ?", "%#{@query}%")
      @combined_results = @results + @results_users + @link_results + @embed_results

      # Ordena aleatoriamente los resultados si ambos conjuntos tienen resultados
      if @combined_results.present?
        @combined_results.shuffle!
      else
        @combined_results = []
      end
    end

    # Ordena los resultados según la opción de clasificación
    if @sort_by.present?
      case @sort_by
      when 'recent_date'
        @combined_results.sort_by! { |result| result.created_at }
        @combined_results.reverse!
        @results = @results.order(created_at: :desc)
      when 'oldest_date'
        @combined_results.sort_by! { |result| result.created_at }
        @results = @results.order(created_at: :asc)
      when 'views'
        @results = @results.order(views: :desc)
        @combined_results = @results.order(views: :desc)
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
