class SubjectsController < ApplicationController

  before_action :signed_in_user
  #before_action :admin_user
  before_action :set_subject, only: [:edit, :update]

  def index
    @subjects = Subject.all.order('name ASC')
  end

  def new
    @subject = Subject.new
  end

  def edit
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      flash[:success] = "Subject successfully added!"
      redirect_to subjects_url
    else
      render 'new'
    end
  end

  def update
    if @subject.update_attributes(subject_params)
      flash[:success] = "Subject updated!"
      redirect_to subjects_url
    else
      render 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name)
    end
end
