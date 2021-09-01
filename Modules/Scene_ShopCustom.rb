class Scene_ShopCustom < Scene_Base
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_background
    @help_window = Window_Help.new
    @help_window.y = -56
    @gold_window = $gold_window
    @buy_window = Window_ShopBuy.new(0, 112)
    @buy_window.active = false
    @buy_window.visible = false
    @buy_window.help_window = @help_window
    @sell_window = Window_ShopSell.new(0, 112, 544, 304)
    @sell_window.active = false
    @sell_window.visible = false
    @sell_window.help_window = @help_window
    @status_window = Window_ShopStatusNumber.new(0, 290, 544, 126)
    @status_window.visible = false

    case $shop_mode
    when 0
      start_buy
    when 1
      start_sell
    end
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @help_window.dispose
    @buy_window.dispose
    @sell_window.dispose
    @status_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @help_window.update
    @gold_window.update
    @buy_window.update
    @sell_window.update
    @status_window.update
    if @status_window.active
      update_number_input
    end
  end
  #--------------------------------------------------------------------------
  # * Create Background for Menu Screen
  #--------------------------------------------------------------------------
  def create_background
    @menuback_sprite = Sprite.new
    @menuback_sprite.bitmap = $game_temp.background_bitmap
    @menuback_sprite.color.set(0, 0, 0, 0)
    update_menu_background
  end
  #--------------------------------------------------------------------------
  # * Update Number Input
  #--------------------------------------------------------------------------
  def update_number_input
    if Input.trigger?(Input::B)
      close_shop
    elsif Input.trigger?(Input::C)
      decide_number_input
      close_shop
    end
  end
  #--------------------------------------------------------------------------
  # * Confirm Number Input
  #--------------------------------------------------------------------------
  def decide_number_input
    Sound.play_shop
    @status_window.active = false
    @status_window.visible = false
    case $shop_mode
    when 0  # Buy
      $game_party.lose_gold(@status_window.number * @item.price)
      $game_party.gain_item(@item, @status_window.number, nil, true)
      @gold_window.refresh
      @status_window.refresh
    when 1  # sell
      $game_party.gain_gold(@status_window.number * (@item.price / 2))
      $game_party.lose_item(@item, @status_window.number, nil, true)
      @gold_window.refresh
      @status_window.refresh
    end
  end

  def start_buy
    Sound.play_decision
    @buy_window.active = true
    @status_window.visible = true

    select_item
  end

  def start_sell
    Sound.play_decision
    @sell_window.active = true
    @status_window.visible = true
  end

  def select_item
    @item = @buy_window.item
    number = $game_party.item_number(@item)
    if @item == nil or @item.price > $game_party.gold or number == 99
      Sound.play_buzzer
    else
      Sound.play_decision
      max = @item.price == 0 ? 99 : $game_party.gold / @item.price
      max = [max, 99 - number].min
      @buy_window.active = false
      @status_window.set(@item, max, @item.price)
      @status_window.active = true
      @status_window.visible = true
    end
  end

  def close_shop
    Sound.play_cancel
    $scene = Scene_Map.new
    Call_Common_Event.new(28) #Update HUD meat counter
  end

end