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
  def initialize(x = 0, y = 288, w = 544, h = 128, with_description = true)
    super(x, y, w, h)
    @with_description = with_description
    @nms = $game_message
    self.opacity = 0
    self.contents.font.name = @nms.nms_fontname
    self.contents.font.size = @nms.nms_fontsize
    self.contents.font.bold = Font.default_bold
    init_help
  end
  def init_help
    @help_window = Window_Help.new(0, 316, 544, 100, true)
    @help_window.opacity = 0
    @help_window.contents.font.name = @nms.nms_fontname
    @help_window.contents.font.size = @nms.nms_fontsize
    @help_window.contents.font.bold = Font.default_bold
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
  def set(item, qText = nil)
    @item = item
    @qText = qText
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @item != nil
      x = 0
      y = 0
      self.contents.font.italic = false
      draw_icon(@item.icon_index, x, y, true)
      if @item.is_a?(RPG::Item)
        draw_items_owned
        draw_item_description if @with_description
      elsif @item.is_a?(RPG::Weapon)
        draw_weapon_params
      end
    end
  end

  def draw_item_description
    desc = @item.description.split(Localization::NEW_LINE_CHAR)
    @help_window.set_text(desc)
  end

  def draw_items_owned
    x = 32
    y = 0
    number = $game_party.item_number(@item)
    item_name = number > 1 ? $local.get_plural(@item) : @item.name
    if item_name == nil
      item_name = @item.name
    end
    quantity = @qText != nil ? @qText : number
    owned_text = $local.get_text("possession")
    self.contents.draw_text(x, y, 544, WLH, "#{item_name}: #{quantity} #{owned_text}")
  end

  def draw_weapon_params
    x = 32
    y = 0
    param = $local.get_text("attack")
    value = @item.atk
    self.contents.font.color = text_color(17)
    self.contents.draw_text(x, y, 544, WLH, "#{@item.name} | #{param}: #{value}")
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
