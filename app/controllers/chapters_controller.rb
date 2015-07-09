class ChaptersController < ApplicationController
  authorize_actions_for Chapter
  before_action :set_chapter, only: [:show, :edit, :update, :destroy, :remove_mission]
  before_filter :authenticate_user!, :except=>[:index, :show]

  def index
    @title = "Chapitres"
    @from_course = false
    @chapters = Chapter.visible_for(current_user)
  end

  def show
    if params[:modal]
      render :modal_show, :layout=>false
    else
      @title = "Chapitre : #{@chapter.title}"
    end
  end

  def new
    @title = "Chapitres"
    @chapters = []
    @from_course = false
    if params[:course_id].nil?
      @title = "Créer un chapitre"
      @chapter = Chapter.new
      render :new
    else
      Chapter.find_each do |chapter|
        if CourseChapterManifest.find_by(:course_id=>params[:course_id], :chapter_id=>chapter.id).nil?
          @chapters.append(chapter)
        end
      end
      @from_course = true
      @course_from = Course.find_by(:id=>params[:course_id])
      render :index
    end
  end



  def create
    @chapter = Chapter.new(chapter_params)

    if @chapter.save
      @chapter.update_attribute :chapter_order_position, :last
      redirect_to chapters_path, notice: "Le chapitre a bien été créé."
    else
      @title = "Créer un chapitre"
      render :new
    end
  end

  def edit
    @title = "Modifier le chapitre : #{@chapter.title}"
  end

  def update
    if @chapter.update(chapter_params)
      redirect_to @chapter, notice: "Le chapitre a bien été mis à jour."
    else
      @title = "Modifier le chapitre : #{@chapter.title}"
      render :edit
    end
  end

  def destroy 
    @chapter.destroy
    redirect_to chapters_url, notice: "Le chapitre a bien été supprimé."
  end

  private
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    def chapter_params
      p = params.require(:chapter).permit(:title, :description, :small_description, :youtube)
      p
    end
end
