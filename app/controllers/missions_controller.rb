class MissionsController < ApplicationController
  authorize_actions_for Mission
  before_action :set_mission, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except=>[:index, :show]

  def index
    @title = "Missions"
    @missions = []
    @from_chapter = false
    if params[:id].nil?
      @missions = Mission.visible_for(current_user)
    else
      Mission.all.each do |mission|
        if ChapterMissionManifest.find_by(:chapter_id=>params[:id], :mission_id=>mission.id).nil?
          @missions.append(mission)
        end
      end
      @from_chapter = true
      @chapter_from = Chapter.find_by(:id=>params[:id])
    end
  end

  def show
    if params[:modal]
      render :modal_show, :layout=>false
    else
      @title = "Mission : #{@mission.title}"
    end
  end

  def new
    @title = "Créer une mission"
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)

    if @mission.save
      @mission.update_attribute :mission_order_position, :last
      redirect_to mission_program_path(@mission), notice: "La mission a bien été créée."
    else
      @title = "Créer une mission"
      render :new
    end
  end

  def edit
    @title = "Modifier la mission : #{@mission.title}"
  end

  def update
    if @mission.update(mission_params)
      redirect_to @mission, notice: "La mission a bien été mise à jour."
    else
      @title = "Modifier la mission : #{@mission.title}"
      render :edit
    end
  end

  def destroy
    @mission.destroy
    redirect_to missions_url, notice: "La mission a bien été supprimée."
  end

  private
    def set_mission
      @mission = Mission.find(params[:id])
    end

    def mission_params
      p = params.require(:mission).permit(:title, :description, :small_description, :source_code, :youtube)

      template = create_template_from_params(p,params)

      name = [p[:title],".xml"]

      file = create_tempfile_from_template(name, template)

      p[:source_code] = file
      p
    end

    def create_template_from_params(p, params)
      if not params[:source_code].eql?("")
        mission = Mission.find_by(:id=>(params[:source_code]).to_i)
        template = create_template_from_title_file_params(mission.title, 
                                                          File.open("#{Rails.root}/public#{mission.source_code.url.split('/')[0..-2].join('/')}/#{mission.source_code_file_name}", "r"),
                                                          p)
      else
        template = create_template_from_title_file_params("Untitled", 
                                                          File.open("#{Rails.root}/public/default_mission.xml", "r"),
                                                          p)
      end
    end

    def create_tempfile_from_template(name, template)
      file = Tempfile.new(name, "#{Rails.root}/tmp")
      file.write(template)
      file.rewind
      file
    end

    def create_template_from_title_file_params(title, file_from, p)
      template = ""
      line = file_from.gets
      while(line) do
        template << line.gsub(title, p[:title])
        line = file_from.gets
      end
      template
    end
end
