class EmbedsController < ApplicationController
    before_action :authenticate_user!, :except => [:show]
    load_and_authorize_resource :except => [:download]
  
    def create
        @embed = Embed.create(embed_params)
            
        respond_to do |format|
            if @embed.persisted?
            format.json {
                render :json => @embed.to_json(:protocol => request.protocol)
            }
            format.html {
                redirect_to polymorphic_path(@embed), notice: I18n.t("documents.messages.success.create")
            }
            else
            format.json {
                return head(:not_found)
            }
            format.html { 
                flash.now[:alert] = @embed.errors.full_messages
                render action: "new"
            }
            end
        end
    end

    def show
      @document = Document.find_by_id(params[:id])
      respond_to do |format|
        format.json {
          render :json => @document.to_json 
        }
        format.html {
          @suggestions = RecommenderSystem.suggestions({:n => 6, :lo_profile => @document.profile, :settings => {}})
        }
        format.any {
          path = @document.file.path(params[:style] || params[:format])
          head(:not_found) and return unless (File.exist?(path) and request.format.nil? == false)
          send_file path,
                   :filename => @document.file_file_name,
                   :disposition => "inline",
                   :type => request.format
        }
      end
    end
  
    def update
      @embed = Embed.find_by_id(params[:id])
      respond_to do |format|
        if @embed.update(embed_params)
          format.html { redirect_to embed_path(@embed), notice: I18n.t("embeds.messages.success.update") }
        else
          format.html {
            flash.now[:alert] = I18n.t("embeds.messages.error.generic_update")
            render action: "edit"
          }
        end
      end
    end
  
    def new
    end
  
    def edit
      @embed = Embed.find_by_id(params[:id])
    end
  
    def destroy
      @embed = Embed.find_by_id(params[:id])
      @embed.destroy
  
      respond_to do |format|
        format.html {
          redirect_to view_context.current_user_path_for("files")
        }
        format.json { head :no_content }
      end
    end
  
    private

    def embed_params
        params.require(:embed).permit(:title, :description, :iframe, :owner_id)
    end
  end
  