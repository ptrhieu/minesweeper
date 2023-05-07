class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show edit update destroy ]

  # GET /boards or /boards.json
  def index
    @boards = Board.all
  end

  # GET /boards/1 or /boards/1.json
  def show
    @mine_positions = @board.mine_positions
    @board_width = @board.width
    @board_height = @board.height
    @page = params[:page].present? ? params[:page].to_i : 1
    @per_page =  params[:per_page].present? ? params[:per_page].to_i : 1000
    from_index = (@page - 1) * @per_page
    to_index = @page * @per_page - 1
    to_index = @board_width * @board.height - 1 if to_index > @board_width * @board.height - 1
    @indexes = (from_index..to_index).to_a

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /boards/new
  def new
    @board = Board.new
    @most_recent_created_boards = Board.order(created_at: :desc).limit(10)
  end

  # POST /boards or /boards.json
  def create
    @board = Board.new(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to board_url(@board), notice: "Board was successfully created." }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1 or /boards/1.json
  def destroy
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url, notice: "Board was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:email, :name, :width, :height, :number_of_mines)
    end
end
