class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index
    
    if params[:card_tag]
      @cards = current_user.cards.tagged_with(params[:card_tag])
    else
      @cards = current_user.cards.search(params[:search])
    end
    @user_tags = current_user.cards.map(&:card_tags).flatten.map(&:name).uniq
    # tag = CardTag.find(c)
    # @cardtag_list = tag.map(&:name)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    # @card = Card.find(params[:id])

    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @card }
    # end
  end

  # GET /cards/new
  # GET /cards/new.json
  def new
    @card = Card.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/1/edit
  def edit
    @card = Card.find(params[:id])
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)
    @card.user_id = current_user.id

    respond_to do |format|
      if @card.save_with_ocr
        format.html { redirect_to action: :index }
        format.json { render json: @card, status: :created, location: @card }
        flash[:notice] = 'Card was successfully created.'
      else
        format.html { render action: "new" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(card_params)
        format.html { redirect_to action: :index }
        format.json { head :no_content }
        flash[:notice] = 'Card was successfully updated.'
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card = Card.find(params[:id])
    @card.card_taggings.each do |tag|
      c = CardTag.joins(:cards).where(card_taggings: {id: tag.id})
      c.first.destroy rescue nil
    end
    @card.card_taggings.destroy_all
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def card_params
      params.require(:card).permit(:card, :ocr_info, :user, :tag_list)
    end
end
