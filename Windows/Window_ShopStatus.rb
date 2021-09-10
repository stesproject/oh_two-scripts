#==============================================================================
# ** Window_ShopStatus
#------------------------------------------------------------------------------
#  This window displays number of items in possession and the actor's equipment
# on the shop screen.
#==============================================================================

class Window_ShopStatus < Window_Base
  TEXT_X = 32
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
    self.contents.font.italic = false
    @help_window = Window_Help.new(x, 316, 544, 100, true)
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
    x = TEXT_X
    y = 0
    number = $game_party.item_number(@item)
    item_name = number > 1 ? $local.get_plural(@item) : @item.name
    if item_name == nil
      item_name = @item.name
    end
    quantity = @qText != nil ? @qText : number
    owned_text = $local.get_text("possession")
    if quantity != ""
      self.contents.draw_text(x, y, 544, WLH, "#{item_name}: #{quantity} #{owned_text}")
    else
      self.contents.draw_text(x, y, 544, WLH, "#{item_name}")
    end
  end

  def draw_weapon_params
    x = TEXT_X
    y = 0
    param = $local.get_text("attack")
    value = @item.atk
    text_width = self.contents.text_size(@item.name).width
    self.contents.draw_text(x, y, text_width, WLH, "#{@item.name}")
    x += text_width
    self.contents.font.color = text_color(17)
    self.contents.draw_text(x, y, 544 - x, WLH, " | #{param}: #{value}")
    self.contents.font.color = normal_color
  end

  def draw_skin_info(item)
    @item = item
    x = 0
    y = 0
    self.contents.clear
    draw_icon(@item.icon_index, x, y, true)
    name = @item.name.upcase
    text_width = self.contents.text_size(name).width
    x += TEXT_X
    self.contents.draw_text(x, y, 544, WLH, "#{name}")
    cheat_data = @item.note.split("/")
    switch_id = cheat_data[0].to_i
    if $game_switches[switch_id] == false
      x += text_width
      t = $local.get_text("locked")
      self.contents.font.color = text_color(10)
      self.contents.draw_text(x, y, 544 - x, WLH, " #{t}")
      self.contents.font.color = normal_color
    end
  end

  def set_help(text)
    @help_window.set_text(text)
  end

  def clear
    self.contents.clear
    @help_window.set_text("")
  end
end
