class LinksController < ApplicationController
    before_action :authenticate_user!, :except => [:show]
    load_and_authorize_resource :except => [:download]
  
    def create
        @link = Link.create(link_params)
            
        respond_to do |format|
            if @link.persisted?
            format.json {
                render :json => @link.to_json(:protocol => request.protocol)
            }
            format.html {
                redirect_to polymorphic_path(@link), notice: I18n.t("documents.messages.success.create")
            }
            else
            format.json {
                return head(:not_found)
            }
            format.html { 
                flash.now[:alert] = @link.errors.full_messages
                render action: "new"
            }
            end
        end
    end

    def show
      @link = Link.find_by_id(params[:id])
      respond_to do |format|
        format.json {
          render :json => @link.to_json 
        }
        format.html {
          @suggestions = RecommenderSystem.suggestions({:n => 6, :lo_profile => @link.profile, :settings => {}})
        }
        format.any {
          path = @link.file.path(params[:style] || params[:format])
          head(:not_found) and return unless (File.exist?(path) and request.format.nil? == false)
          send_file path,
                   :filename => @link.file_file_name,
                   :disposition => "inline",
                   :type => request.format
        }
      end
    end
  
    def update
      @link = Link.find_by_id(params[:id])
      respond_to do |format|
        if @link.update(link_params)
          format.html { redirect_to link_path(@link), notice: I18n.t("links.messages.success.update") }
        else
          format.html {
            flash.now[:alert] = I18n.t("links.messages.error.generic_update")
            render action: "edit"
          }
        end
      end
    end
  
    def new
    end
  
    def edit
      @link = Link.find_by_id(params[:id])
    end
  
    def destroy
      @link = Link.find_by_id(params[:id])
      @link.destroy
  
      respond_to do |format|
        format.html {
          redirect_to view_context.current_user_path_for("files")
        }
        format.json { head :no_content }
      end
    end
  
    private

    def link_params
        params.require(:link).permit(:title, :description, :url, :owner_id)
    end
  end
  