class QueuedUsersController < ApplicationController
  before_action :set_queued_user, only: [:show, :edit, :update, :destroy]

  # GET /queued_users
  # GET /queued_users.json
  def index
    @queued_users = QueuedUser.all
  end

  # GET /queued_users/1
  # GET /queued_users/1.json
  def show
  end

  # GET /queued_users/new
  def new
    @queued_user = QueuedUser.new
  end

  # GET /queued_users/1/edit
  def edit
  end

  # POST /queued_users
  # POST /queued_users.json
  def create
    @queued_user = QueuedUser.new(create_user_params)
    @queued_user.confirm_token = SecureRandom.hex

    respond_to do |format|
      if @queued_user.save && @queued_user.send_confirmation!
        format.html { redirect_to queued_user_path(@queued_user), notice: "Confirm your phone number to get in the queue" }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /queued_users/1
  # PATCH/PUT /queued_users/1.json
  def update
    respond_to do |format|
      if @queued_user.update(queued_user_params) && @queued_user.send_confirmation!
        format.html { redirect_to queued_user_path(@queued_user), notice: "Confirm your phone number to get in the queue" }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /queued_users/1
  # DELETE /queued_users/1.json
  def destroy
    @queued_user.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: "You're deleted from the queue" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_queued_user
      @queued_user = QueuedUser.find(find_user_params[:id])
      unless @queued_user.valid_token?(find_user_params[:confirm_token])
        redirect_to '/', notice: "Token not valid"
      end
    end

    def find_user_params
      params.permit(:id, :confirm_token)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_user_params
      params.require(:queued_user).permit(:name, :number)
    end
end
