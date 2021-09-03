#==============================================================================
# ** Window_ShopStatus
#------------------------------------------------------------------------------
#  This window displays number of items in possession and the actor's equipment
# on the shop screen.
#==============================================================================

class Window_ShopStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #--------------------------------------------------------------------------
  def initialize(x = 0, y = 288, w = 544, h = 128)
    super(x, y, w, h)
    self.opacity = 0
    init_help
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @help_window.dispose
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #--------------------------------------------------------------------------
  def set(item)
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @item != nil
      y = 0
      self.contents.font.italic = false
      text_width = self.contents.text_size(@item.name).width
      text_width += 20
      symbol = @item.is_a?(RPG::Item) ? ":" : "" 
      draw_item_name(@item, 0, y, true, text_width, symbol)
      if @item.is_a?(RPG::Item)
        draw_items_owned(text_width, y)
        draw_item_description
      elsif @item.is_a?(RPG::Weapon)
        draw_weapon_params(text_width, y)
      end
    end
  end

  def init_help
    @help_window = Window_Help.new(0, 316, 544, 100, true)
    @help_window.opacity = 0
  end

  def draw_item_description
    desc = @item.description.split(Localization::NEW_LINE_CHAR)
    @help_window.set_text(desc)
  end

  def draw_items_owned(width, y)
    number = $game_party.item_number(@item)
    owned = $local.get_text("possession")
    self.contents.draw_text(width + 10, y, 32, WLH, number, 2)
    self.contents.draw_text(width + 44, y, 180, WLH, " #{owned}")
  end

  def draw_weapon_params(width, y)
    param = $local.get_text("attack")
    value = @item.atk
    self.contents.font.color = text_color(17)
    self.contents.draw_text(width + 20, y, 64, WLH, "| #{param}:")
    self.contents.draw_text(width + 76, y, 32, WLH, " #{value}")
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #     item : new item
  #--------------------------------------------------------------------------
  def item=(item)
    if @item != item
      @item = item
      refresh
    end
  end

  def clear
    self.contents.clear
    @help_window.set_text("")
  end
end
