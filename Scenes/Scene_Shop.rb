#==============================================================================
# ** Scene_Shop
#------------------------------------------------------------------------------
#  This class performs shop screen processing.
#==============================================================================
class Scene_Shop < Scene_Base
  ONE_AVAILABLE = [13] #Item ids whose only one unit is available
  SWORDS_VARIABLE_ID = 13
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_background
    load_items

    @help_window = Window_Help.new(0, 316, 544, 100, true)
    @help_window.visible = false
    @help_window.active = false
    @gold_window = $gold_window
    @status_window = Window_ShopNumber.new(0, 316, 544, 100)
    @status_window.visible = false
    @status_window.active = false

    case $shop_mode
    when 0
      buy_item
    when 1
      sell_item
    end
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @help_window.dispose
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
    @status_window.update
    if @status_window.active || @help_window.active
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
  # * Set Items
  #--------------------------------------------------------------------------
  def load_items
    @items = []
    for goods_item in $game_temp.shop_goods
      case goods_item[0]
      when 0
        item = $data_items[goods_item[1]]
      when 1
        item = $data_weapons[goods_item[1]]
      when 2
        item = $data_armors[goods_item[1]]
      end
      if item != nil
        @items.push(item)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Number Input
  #--------------------------------------------------------------------------
  def update_number_input
    if Input.trigger?(Input::B)
      close_shop
    elsif Input.trigger?(Input::C)
      if !@help_window.active
        decide_number_input
      end
      close_shop
    end
  end
  #--------------------------------------------------------------------------
  # * Confirm Number Input
  #--------------------------------------------------------------------------
  def decide_number_input
    Sound.play_shop
    @status_window.active = false
    case $shop_mode
    when 0  # Buy
      $game_party.lose_gold(@status_window.number * @item.price)
      $game_party.gain_item(@item, @status_window.number)
      @gold_window.refresh
      @status_window.refresh
      if @item.is_a?(RPG::Weapon)
        unlock_weapon
      end
    when 1  # sell
      $game_party.gain_gold(@status_window.number * (@item.price / 2))
      $game_party.lose_item(@item, @status_window.number)
      @gold_window.refresh
      @status_window.refresh
    end
  end

  def buy_item
    @item = @items[0]
    number = $game_party.item_number(@item)
    if @item == nil or @item.price > $game_party.gold or number >= 99
      Sound.play_buzzer
      if @item.price > $game_party.gold
        text = $local.set_common_msg("not_enough_d")
        show_msg($local.get_msg_vars[0])
      elsif number >= 99
        show_msg("Not available.")
      end
    else
      Audio.se_play("Audio/SE/GetReward", 80, 100)
      max = @item.price == 0 ? 99 : $game_party.gold / @item.price
      max = [max, 99 - number].min
      max = ONE_AVAILABLE.include?(@item.id) || @item.is_a?(RPG::Weapon) ? 1 : max
      @status_window.active = true
      @status_window.set(@item, max, @item.price)
      @status_window.visible = true
    end
  end

  def sell_item
    @item = @items[0]
    if @item == nil or @item.price == 0
      Sound.play_buzzer
    else
      Audio.se_play("Audio/SE/GetReward", 80, 100)
      max = $game_party.item_number(@item)
      @status_window.active = true
      @status_window.set(@item, max, @item.price / 2)
      @status_window.visible = true
    end
  end

  def show_msg(msg)
    @help_window.set_text(msg)
    @help_window.active = true
    @help_window.visible = true
  end

  def unlock_weapon
    switch_id = @item.spi
    if switch_id > 0
      $game_switches[switch_id] = true
      $game_variables[SWORDS_VARIABLE_ID] += 1
    end
  end

  def close_shop
    Sound.play_cancel
    $scene = Scene_Map.new
  end
end