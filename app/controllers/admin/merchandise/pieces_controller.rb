class Admin::Merchandise::PiecesController < ApplicationController
  # GET /admin/merchandise/pieces
  # GET /admin/merchandise/pieces.json
  def index
    @admin_merchandise_pieces = Admin::Merchandise::Piece.order('active desc, category desc, name asc')
    @record_count             = @admin_merchandise_pieces.count
    @admin_merchandise_pieces = @admin_merchandise_pieces.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_merchandise_pieces }
    end
  end

  # GET /admin/merchandise/pieces/1
  # GET /admin/merchandise/pieces/1.json
  def show
    @admin_merchandise_piece = Admin::Merchandise::Piece.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_merchandise_piece }
    end
  end

  # GET /admin/merchandise/pieces/new
  # GET /admin/merchandise/pieces/new.json
  def new
    @admin_merchandise_piece = Admin::Merchandise::Piece.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_merchandise_piece }
    end
  end

  # GET /admin/merchandise/pieces/1/edit
  def edit
    @admin_merchandise_piece = Admin::Merchandise::Piece.find(params[:id])
  end

  # POST /admin/merchandise/pieces
  # POST /admin/merchandise/pieces.json
  def create
    @admin_merchandise_piece = Admin::Merchandise::Piece.new(params[:admin_merchandise_piece])

    respond_to do |format|
      if @admin_merchandise_piece.save
        format.html { redirect_to @admin_merchandise_piece, notice: 'Piece was successfully created.' }
        format.json { render json: @admin_merchandise_piece, status: :created, location: @admin_merchandise_piece }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_merchandise_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/merchandise/pieces/1
  # PUT /admin/merchandise/pieces/1.json
  def update
    @admin_merchandise_piece = Admin::Merchandise::Piece.find(params[:id])

    respond_to do |format|
      if @admin_merchandise_piece.update_attributes(params[:admin_merchandise_piece])
        format.html { redirect_to @admin_merchandise_piece, notice: 'Piece was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_merchandise_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/merchandise/pieces/1
  # DELETE /admin/merchandise/pieces/1.json
  def destroy
    @admin_merchandise_piece = Admin::Merchandise::Piece.find(params[:id])
    @admin_merchandise_piece.destroy

    respond_to do |format|
      format.html { redirect_to admin_merchandise_pieces_url }
      format.json { head :ok }
    end
  end
end
